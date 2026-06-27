using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace DNB
{
    public static class DB
    {
        static string CS => ConfigurationManager.ConnectionStrings["DNBConn"].ConnectionString;

        public static string HashPassword(string password)
        {
            using (var sha = SHA256.Create())
            {
                byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(password + "DNB_SALT_KEY_2024"));
                var sb = new StringBuilder();
                foreach (byte b in bytes) sb.Append(b.ToString("x2"));
                return sb.ToString();
            }
        }

        public static DataTable Query(string sql, params SqlParameter[] p)
        {
            var dt = new DataTable();
            using (var c = new SqlConnection(CS))
            using (var cmd = new SqlCommand(sql, c))
            {
                if (p != null) cmd.Parameters.AddRange(p);
                c.Open();
                new SqlDataAdapter(cmd).Fill(dt);
            }
            return dt;
        }

        public static int Execute(string sql, params SqlParameter[] p)
        {
            using (var c = new SqlConnection(CS))
            using (var cmd = new SqlCommand(sql, c))
            {
                cmd.CommandTimeout = 30;
                if (p != null) cmd.Parameters.AddRange(p);
                c.Open(); return cmd.ExecuteNonQuery();
            }
        }

        public static object Scalar(string sql, params SqlParameter[] p)
        {
            using (var c = new SqlConnection(CS))
            using (var cmd = new SqlCommand(sql, c))
            {
                if (p != null) cmd.Parameters.AddRange(p);
                c.Open(); return cmd.ExecuteScalar();
            }
        }

        public static SqlParameter P(string name, object val) =>
            new SqlParameter(name, val ?? (object)DBNull.Value);

        public static void EnsureDatabase()
        {
            try
            {
                Execute(@"IF NOT EXISTS(SELECT*FROM sysobjects WHERE name='Admin' AND xtype='U')
CREATE TABLE Admin(AdminID INT IDENTITY PRIMARY KEY,Username NVARCHAR(50) NOT NULL UNIQUE,
Password NVARCHAR(256) NOT NULL,FullName NVARCHAR(100) NOT NULL DEFAULT 'Administrator',
CreatedDate DATETIME NOT NULL DEFAULT GETDATE())");

                Execute(@"IF NOT EXISTS(SELECT*FROM sysobjects WHERE name='Students' AND xtype='U')
CREATE TABLE Students(StudentID INT IDENTITY PRIMARY KEY,Username NVARCHAR(50) NOT NULL UNIQUE,
Email NVARCHAR(150) NOT NULL UNIQUE,Password NVARCHAR(256) NOT NULL,
FullName NVARCHAR(100) NOT NULL DEFAULT '',CreatedDate DATETIME NOT NULL DEFAULT GETDATE())");

                Execute(@"IF NOT EXISTS(SELECT*FROM sysobjects WHERE name='Notices' AND xtype='U')
CREATE TABLE Notices(NoticeID INT IDENTITY PRIMARY KEY,Title NVARCHAR(200) NOT NULL,
Description NVARCHAR(MAX) NOT NULL,ImagePath NVARCHAR(500) NULL,PDFPath NVARCHAR(500) NULL,
Category NVARCHAR(50) NOT NULL DEFAULT 'Announcements',IsPinned BIT NOT NULL DEFAULT 0,
UploadDate DATETIME NOT NULL DEFAULT GETDATE(),UploadedByAdmin NVARCHAR(50) NOT NULL DEFAULT 'admin',
IsActive BIT NOT NULL DEFAULT 1)");

                // Safe upgrade columns for existing installs
                try { Execute("IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('Notices') AND name='PDFPath') ALTER TABLE Notices ADD PDFPath NVARCHAR(500) NULL"); } catch { }
                try { Execute("IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('Notices') AND name='Category') ALTER TABLE Notices ADD Category NVARCHAR(50) NOT NULL DEFAULT 'Announcements'"); } catch { }
                try { Execute("IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('Notices') AND name='IsPinned') ALTER TABLE Notices ADD IsPinned BIT NOT NULL DEFAULT 0"); } catch { }

                Execute(@"IF NOT EXISTS(SELECT*FROM sysobjects WHERE name='Messages' AND xtype='U')
CREATE TABLE Messages(MessageID INT IDENTITY PRIMARY KEY,StudentID INT NOT NULL,NoticeID INT NULL,
Subject NVARCHAR(200) NOT NULL,MessageText NVARCHAR(MAX) NOT NULL,
SentDate DATETIME NOT NULL DEFAULT GETDATE(),ReplyText NVARCHAR(MAX) NULL,
ReplyDate DATETIME NULL,IsRead BIT NOT NULL DEFAULT 0,
FOREIGN KEY(StudentID) REFERENCES Students(StudentID),
FOREIGN KEY(NoticeID) REFERENCES Notices(NoticeID))");

                Execute("IF NOT EXISTS(SELECT 1 FROM Admin WHERE Username='admin') " +
                        "INSERT INTO Admin(Username,Password,FullName) VALUES('admin',@pw,'System Administrator')",
                        P("@pw", HashPassword("Admin@123")));

                Execute(@"IF NOT EXISTS(SELECT 1 FROM Notices)
BEGIN
INSERT INTO Notices(Title,Description,Category,IsPinned,UploadedByAdmin)VALUES
('Welcome to Digital Notice Board','This is the official Digital Notice Board portal. All important announcements, academic updates, campus events and notices are published here. Students are advised to check regularly.','Announcements',1,'admin'),
('End Semester Exam Schedule Released','The End Semester Examination schedule has been officially released. Download your hall ticket from the portal at least 3 days before your exam date. Students without a hall ticket will not be permitted to appear.','Exams',1,'admin'),
('Annual Sports Day - Registrations Open','Registrations for Annual Sports Day are now open! Events include Cricket, Football, Basketball, Table Tennis and 100m Sprint. Register with your department sports coordinator before the deadline.','Events',0,'admin'),
('Campus Placement Drive - Companies Visiting','Top IT and core companies are visiting campus for recruitment. Final-year eligible students must submit resumes to the placement cell. Formal dress code is mandatory.','Announcements',0,'admin'),
('Library Timings Revised','New library timings: Mon-Fri 8AM-10PM, Sat 9AM-6PM, Sun 10AM-4PM. Digital resources available 24x7 via the online portal. Always carry your valid ID card.','Announcements',0,'admin'),
('Mini Project Submission Deadline','All 6th semester students must submit their mini project reports and source code to their respective project guides before the deadline. Late submissions will not be accepted. Ensure your report follows the prescribed format.','Assignments',1,'admin'),
('Lab Record Submission - Last Date','Students of all branches are reminded to submit their completed lab records for the current semester. Incomplete records will result in internal mark deduction. Contact your lab instructor for any queries.','Assignments',0,'admin'),
('Cultural Fest 2025 - Volunteers Needed','The annual Cultural Fest is back! We are looking for enthusiastic volunteers to help with event coordination, stage management, and hospitality. Interested students can register at the student union office.','Events',0,'admin')
END");
            }
            catch { }
        }

        // ─── Admin ───────────────────────────────────────────────────────
        public static DataRow AdminLogin(string u, string pw)
        {
            var dt = Query("SELECT AdminID,Username,FullName FROM Admin WHERE Username=@u AND Password=@p",
                           P("@u", u), P("@p", HashPassword(pw)));
            return dt.Rows.Count > 0 ? dt.Rows[0] : null;
        }

        // ─── Students ────────────────────────────────────────────────────
        public static DataRow StudentLogin(string u, string pw)
        {
            var dt = Query("SELECT StudentID,Username,FullName,Email FROM Students WHERE Username=@u AND Password=@p",
                           P("@u", u), P("@p", HashPassword(pw)));
            return dt.Rows.Count > 0 ? dt.Rows[0] : null;
        }

        public static bool UsernameExists(string u) =>
            Convert.ToInt32(Scalar("SELECT COUNT(1) FROM Students WHERE Username=@u", P("@u", u))) > 0;

        public static bool EmailExists(string e) =>
            Convert.ToInt32(Scalar("SELECT COUNT(1) FROM Students WHERE Email=@e", P("@e", e))) > 0;

        public static void RegisterStudent(string u, string email, string fullname, string pw) =>
            Execute("INSERT INTO Students(Username,Email,FullName,Password,CreatedDate)VALUES(@u,@e,@fn,@p,GETDATE())",
                    P("@u", u), P("@e", email), P("@fn", fullname), P("@p", HashPassword(pw)));

        public static DataTable GetAllStudents() =>
            Query("SELECT StudentID,Username,Email,FullName,CreatedDate FROM Students ORDER BY CreatedDate DESC");

        // ─── Notices CRUD ─────────────────────────────────────────────────
        public static DataTable GetAllNotices() =>
            Query("SELECT * FROM Notices WHERE IsActive=1 ORDER BY IsPinned DESC, UploadDate DESC");

        public static DataTable GetNoticesByCategory(string cat)
        {
            // Derive singular form (strip trailing 's') for backward-compat with older rows
            // e.g. "Announcements" -> also matches "Announcement"
            string singular = (cat != null && cat.EndsWith("s") && cat.Length > 1)
                              ? cat.Substring(0, cat.Length - 1) : cat;
            string sql = @"SELECT * FROM Notices
                           WHERE IsActive=1
                             AND (Category = @c
                               OR Category = @cs
                               OR Category LIKE @cl
                               OR Category LIKE @csl)
                           ORDER BY IsPinned DESC, UploadDate DESC";
            return Query(sql,
                P("@c",   cat),
                P("@cs",  singular),
                P("@cl",  cat    + "%"),
                P("@csl", singular + "%"));
        }

        public static DataTable SearchNotices(string q) =>
            Query("SELECT * FROM Notices WHERE IsActive=1 AND (Title LIKE @q OR Description LIKE @q) ORDER BY IsPinned DESC, UploadDate DESC",
                  P("@q", "%" + q + "%"));

        public static DataRow GetNotice(int id)
        {
            var dt = Query("SELECT * FROM Notices WHERE NoticeID=@id", P("@id", id));
            return dt.Rows.Count > 0 ? dt.Rows[0] : null;
        }

        public static int CreateNotice(string title, string desc, string imgPath, string pdfPath, string category, bool isPinned, string by)
        {
            var v = Scalar("INSERT INTO Notices(Title,Description,ImagePath,PDFPath,Category,IsPinned,UploadedByAdmin,UploadDate)" +
                           "VALUES(@t,@d,@i,@pdf,@cat,@pin,@b,GETDATE());SELECT SCOPE_IDENTITY();",
                           P("@t", title), P("@d", desc), P("@i", imgPath), P("@pdf", pdfPath),
                           P("@cat", category), P("@pin", isPinned), P("@b", by));
            return Convert.ToInt32(v);
        }

        public static void UpdateNotice(int id, string title, string desc, string imgPath, string pdfPath, string category, bool isPinned)
        {
            string sql = "UPDATE Notices SET Title=@t,Description=@d,Category=@cat,IsPinned=@pin";
            var ps = new System.Collections.Generic.List<SqlParameter> {
                P("@t", title), P("@d", desc), P("@cat", category), P("@pin", isPinned)
            };
            if (!string.IsNullOrEmpty(imgPath)) { sql += ",ImagePath=@i"; ps.Add(P("@i", imgPath)); }
            if (!string.IsNullOrEmpty(pdfPath)) { sql += ",PDFPath=@pdf"; ps.Add(P("@pdf", pdfPath)); }
            sql += " WHERE NoticeID=@id";
            ps.Add(P("@id", id));
            Execute(sql, ps.ToArray());
        }

        public static void ClearNoticeImage(int id) =>
            Execute("UPDATE Notices SET ImagePath=NULL WHERE NoticeID=@id", P("@id", id));

        public static void ClearNoticePDF(int id) =>
            Execute("UPDATE Notices SET PDFPath=NULL WHERE NoticeID=@id", P("@id", id));

        public static void DeleteNotice(int id) =>
            Execute("DELETE FROM Notices WHERE NoticeID=@id", P("@id", id));

        public static void TogglePin(int id) =>
            Execute("UPDATE Notices SET IsPinned=CASE WHEN IsPinned=1 THEN 0 ELSE 1 END WHERE NoticeID=@id", P("@id", id));

        // ─── Messages ─────────────────────────────────────────────────────
        public static void SendMessage(int studentId, int? noticeId, string subject, string msgText)
        {
            Execute("INSERT INTO Messages(StudentID,NoticeID,Subject,MessageText,SentDate)" +
                    "VALUES(@sid,@nid,@sub,@msg,GETDATE())",
                    P("@sid", studentId), P("@nid", (object)noticeId ?? DBNull.Value),
                    P("@sub", subject), P("@msg", msgText));
        }

        public static DataTable GetAllMessages() =>
            Query(@"SELECT m.*,s.FullName AS StudentName,s.Username,s.Email,
                    n.Title AS NoticeTitle FROM Messages m
                    JOIN Students s ON m.StudentID=s.StudentID
                    LEFT JOIN Notices n ON m.NoticeID=n.NoticeID
                    ORDER BY m.SentDate DESC");

        public static DataTable GetStudentMessages(int studentId) =>
            Query(@"SELECT m.*,n.Title AS NoticeTitle FROM Messages m
                    LEFT JOIN Notices n ON m.NoticeID=n.NoticeID
                    WHERE m.StudentID=@sid ORDER BY m.SentDate DESC", P("@sid", studentId));

        public static DataRow GetMessage(int msgId)
        {
            var dt = Query(@"SELECT m.*,s.FullName AS StudentName,s.Username,s.Email,
                    n.Title AS NoticeTitle FROM Messages m
                    JOIN Students s ON m.StudentID=s.StudentID
                    LEFT JOIN Notices n ON m.NoticeID=n.NoticeID
                    WHERE m.MessageID=@id", P("@id", msgId));
            return dt.Rows.Count > 0 ? dt.Rows[0] : null;
        }

        public static void ReplyMessage(int msgId, string reply) =>
            Execute("UPDATE Messages SET ReplyText=@r,ReplyDate=GETDATE() WHERE MessageID=@id",
                    P("@r", reply), P("@id", msgId));

        public static void MarkStudentRepliesRead(int studentId) =>
            Execute("UPDATE Messages SET IsRead=1 WHERE StudentID=@sid AND ReplyText IS NOT NULL", P("@sid", studentId));

        // ─── Stats ────────────────────────────────────────────────────────
        public static int CountNotices() => Convert.ToInt32(Scalar("SELECT COUNT(1) FROM Notices WHERE IsActive=1"));
        public static int CountStudents() => Convert.ToInt32(Scalar("SELECT COUNT(1) FROM Students"));
        public static int CountToday() => Convert.ToInt32(Scalar("SELECT COUNT(1) FROM Notices WHERE IsActive=1 AND CAST(UploadDate AS DATE)=CAST(GETDATE() AS DATE)"));
        public static int CountImages() => Convert.ToInt32(Scalar("SELECT COUNT(1) FROM Notices WHERE IsActive=1 AND ImagePath IS NOT NULL AND ImagePath<>''"));
        public static int CountMessages() => Convert.ToInt32(Scalar("SELECT COUNT(1) FROM Messages"));
        public static int CountPendingReplies() => Convert.ToInt32(Scalar("SELECT COUNT(1) FROM Messages WHERE ReplyText IS NULL OR ReplyText=''"));
        public static int CountStudentNewReplies(int studentId) =>
            Convert.ToInt32(Scalar("SELECT COUNT(1) FROM Messages WHERE StudentID=@sid AND ReplyText IS NOT NULL AND ReplyText<>'' AND IsRead=0",
                P("@sid", studentId)));
    }
}
