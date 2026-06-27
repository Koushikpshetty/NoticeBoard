using System;
using System.Web.UI;
namespace DNB
{
    public partial class Students : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminUser"] == null) { Response.Redirect("~/AdminLogin.aspx"); return; }
            string name = Session["AdminName"] as string ?? "Admin";
            lblName.Text = name; lblAv.Text = name.Length > 0 ? name[0].ToString().ToUpper() : "A";
            if (!IsPostBack)
            {
                var dt = DB.GetAllStudents();
                lblCount.Text = dt.Rows.Count.ToString();
                gv.DataSource = dt;
                gv.DataBind();
            }
        }
    }
}
