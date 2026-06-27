using System;
using System.Web.UI;
namespace DNB
{
    public partial class MyMessages : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["StudentUser"] == null) { Response.Redirect("~/StudentLogin.aspx"); return; }
            if (!IsPostBack)
            {
                int sid = Convert.ToInt32(Session["StudentID"] ?? 0);
                if (sid > 0)
                {
                    // Mark replies as read
                    DB.MarkStudentRepliesRead(sid);
                    var dt = DB.GetStudentMessages(sid);
                    if (dt.Rows.Count == 0) { pnlEmpty.Visible = true; rpt.Visible = false; }
                    else { pnlEmpty.Visible = false; rpt.Visible = true; rpt.DataSource = dt; rpt.DataBind(); }
                }
            }
        }
    }
}
