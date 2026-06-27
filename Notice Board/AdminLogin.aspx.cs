using System;
using System.Web.UI;
namespace DNB
{
    public partial class AdminLogin : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminUser"] != null) Response.Redirect("~/AdminDashboard.aspx");
        }
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            try
            {
                var row = DB.AdminLogin(txtUser.Text.Trim(), txtPwd.Text);
                if (row != null)
                {
                    Session["AdminUser"] = row["Username"].ToString();
                    Session["AdminName"] = row["FullName"].ToString();
                    Response.Redirect("~/AdminDashboard.aspx");
                }
                else { pnlErr.Visible = true; lblErr.Text = "Invalid username or password. Please try again."; }
            }
            catch (Exception ex) { pnlErr.Visible = true; lblErr.Text = "Error: " + ex.Message; }
        }
    }
}
