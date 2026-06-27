using System;
using System.Web.UI;
namespace DNB
{
    public partial class Home : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try { lblNotices.Text = DB.CountNotices().ToString();
                      lblStudents.Text = DB.CountStudents().ToString();
                      lblToday.Text = DB.CountToday().ToString(); }
                catch { }
            }
        }
    }
}
