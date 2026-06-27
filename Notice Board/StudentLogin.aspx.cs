using System;
using System.Web.UI;
namespace DNB
{
    public partial class StudentLogin : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["StudentUser"] != null) Response.Redirect("~/StudentDashboard.aspx");
        }
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            try
            {
                var row = DB.StudentLogin(txtUser.Text.Trim(), txtPwd.Text);
                if (row != null)
                {
                    Session["StudentUser"]  = row["Username"].ToString();
                    Session["StudentName"]  = row["FullName"].ToString();
                    Session["StudentEmail"] = row["Email"].ToString();
                    Session["StudentID"]    = Convert.ToInt32(row["StudentID"]);
                    Response.Redirect("~/StudentDashboard.aspx");
                }
                else { pnlErr.Visible = true; lblErr.Text = "Invalid username or password. Please try again."; }
            }
            catch (Exception ex) { pnlErr.Visible = true; lblErr.Text = "Error: " + ex.Message; }
        }
    }
}
