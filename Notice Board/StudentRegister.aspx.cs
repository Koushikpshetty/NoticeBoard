using System;
using System.Web.UI;
namespace DNB
{
    public partial class StudentRegister : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["StudentUser"] != null) Response.Redirect("~/StudentDashboard.aspx");
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            pnlErr.Visible = false;
            pnlOk.Visible = false;

            string username = txtUser.Text.Trim();
            string email    = txtEmail.Text.Trim().ToLower();
            string fullname = txtFullName.Text.Trim();
            string password = txtPwd.Text;

            try
            {
                // Check duplicate username
                if (DB.UsernameExists(username))
                {
                    pnlErr.Visible = true;
                    lblErr.Text = "Username '" + Server.HtmlEncode(username) + "' is already taken. Please choose another.";
                    return;
                }

                // Check duplicate email
                if (DB.EmailExists(email))
                {
                    pnlErr.Visible = true;
                    lblErr.Text = "An account with this email already exists.";
                    return;
                }

                // Register student
                DB.RegisterStudent(username, email, fullname, password);

                pnlOk.Visible = true;
                lblOk.Text = "Account created successfully! Welcome, " + Server.HtmlEncode(fullname) + "! Please login to continue.";

                // Clear form
                txtUser.Text = txtEmail.Text = txtFullName.Text = txtPwd.Text = txtConfirm.Text = "";
            }
            catch (Exception ex)
            {
                pnlErr.Visible = true;
                lblErr.Text = "Registration error: " + ex.Message;
            }
        }
    }
}
