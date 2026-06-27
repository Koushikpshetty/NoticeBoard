using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
namespace DNB
{
    public partial class StudentDashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["StudentUser"] == null) { Response.Redirect("~/StudentLogin.aspx"); return; }
            string name = Session["StudentName"] as string ?? "Student";
            lblName.Text = name;
            lblFirstName.Text = name.Contains(" ") ? name.Split(' ')[0] : name;
            lblAv.Text = name.Length > 0 ? name[0].ToString().ToUpper() : "S";

            // Check for new replies
            int sid = Convert.ToInt32(Session["StudentID"] ?? 0);
            if (sid > 0)
            {
                int newReplies = DB.CountStudentNewReplies(sid);
                if (newReplies > 0)
                {
                    pnlNewReply.Visible = true;
                    lblNewReplies.Text = newReplies.ToString();
                    lblNewReplies.Visible = true;
                }
            }

            if (!IsPostBack) LoadNotices(DB.GetAllNotices());
        }

        void LoadNotices(DataTable dt)
        {
            lblNotices.Text  = DB.CountNotices().ToString();
            lblStudents.Text = DB.CountStudents().ToString();
            lblToday.Text    = DB.CountToday().ToString();
            lblCount.Text    = dt.Rows.Count.ToString();
            if (dt.Rows.Count == 0) { pnlEmpty.Visible = true; rpt.Visible = false; }
            else { pnlEmpty.Visible = false; rpt.Visible = true; rpt.DataSource = dt; rpt.DataBind(); }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string q = txtSearch.Text.Trim();
            DataTable dt = string.IsNullOrEmpty(q) ? DB.GetAllNotices() : DB.SearchNotices(q);
            LoadNotices(dt);
        }

        protected void Filter_Click(object sender, EventArgs e)
        {
            var btn = sender as LinkButton;
            string cat = btn?.CommandArgument;
            // Store active filter for UI restoration after postback
            ViewState["ActiveFilter"] = cat ?? "All";
            // Update button active state server-side
            SetFilterActive(cat ?? "All");
            DataTable dt = (cat == null || cat == "All") ? DB.GetAllNotices() : DB.GetNoticesByCategory(cat);
            LoadNotices(dt);
        }

        void SetFilterActive(string active)
        {
            btnAll.CssClass    = "filter-btn" + (active == "All"           ? " active" : "");
            btnAnn.CssClass    = "filter-btn" + (active == "Announcements" ? " active" : "");
            btnExam.CssClass   = "filter-btn" + (active == "Exams"         ? " active" : "");
            btnEvents.CssClass = "filter-btn" + (active == "Events"        ? " active" : "");
            btnAssign.CssClass = "filter-btn" + (active == "Assignments"   ? " active" : "");
        }

        protected void btnSendMsg_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) { ViewState["keepModal"] = true; return; }
            try
            {
                int sid = Convert.ToInt32(Session["StudentID"] ?? 0);
                if (sid <= 0) { ShowMsgErr("Session expired. Please login again."); return; }
                int noticeId;
                int? nid = int.TryParse(hfNoticeId.Value, out noticeId) && noticeId > 0 ? (int?)noticeId : null;
                DB.SendMessage(sid, nid, txtSubject.Text.Trim(), txtMessage.Text.Trim());
                pnlMsgOk.Visible = true;
                lblMsgOk.Text = "Message sent to admin successfully!";
                pnlMsgErr.Visible = false;
                txtSubject.Text = txtMessage.Text = "";
                ViewState["keepModal"] = true;
                LoadNotices(DB.GetAllNotices());
            }
            catch (Exception ex) { ShowMsgErr("Error: " + ex.Message); }
        }

        void ShowMsgErr(string msg)
        {
            pnlMsgErr.Visible = true; lblMsgErr.Text = msg;
            ViewState["keepModal"] = true;
        }

        protected string GetNoticeImage(string p)
        {
            if (!string.IsNullOrEmpty(p))
                return "<img src='" + ResolveUrl(p) + "' class='nc-img' alt='Notice Image'/>";
            return "<div class='nc-img-ph'><i class='fas fa-newspaper'></i></div>";
        }

        protected string GetDescription(string t)
        {
            if (string.IsNullOrEmpty(t)) return "";
            return Server.HtmlEncode(t.Length > 150 ? t.Substring(0, 150) + "…" : t);
        }

        protected string GetCatBadge(string cat)
        {
            if (string.IsNullOrEmpty(cat)) cat = "General";
            return $"<span class='cat-badge cat-{System.Net.WebUtility.HtmlEncode(cat)}'>{System.Net.WebUtility.HtmlEncode(cat)}</span>";
        }

        protected string GetPDFLink(string pdf)
        {
            if (string.IsNullOrEmpty(pdf)) return "";
            return $"<a href='{ResolveUrl(pdf)}' target='_blank' class='nc-pdf-link'><i class='fas fa-file-pdf me-1'></i>View / Download PDF</a>";
        }
    }
}
