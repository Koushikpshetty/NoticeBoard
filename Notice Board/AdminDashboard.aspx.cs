using System;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
namespace DNB
{
    public partial class AdminDashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminUser"] == null) { Response.Redirect("~/AdminLogin.aspx"); return; }
            string name = Session["AdminName"] as string ?? "Admin";
            lblName.Text = name;
            lblAv.Text = name.Length > 0 ? name[0].ToString().ToUpper() : "A";
            if (!IsPostBack) LoadAll();
        }

        void LoadAll()
        {
            try
            {
                lblTotal.Text    = DB.CountNotices().ToString();
                lblToday.Text    = DB.CountToday().ToString();
                lblStudents.Text = DB.CountStudents().ToString();
                lblImages.Text   = DB.CountImages().ToString();
                int msgs = DB.CountMessages();
                int pending = DB.CountPendingReplies();
                lblMessages.Text = msgs.ToString();
                lblPending.Text  = pending.ToString();
                if (pending > 0) { lblMsgBadge.Text = pending.ToString(); lblMsgBadge.Visible = true; }
                gv.DataSource = DB.GetAllNotices();
                gv.DataBind();
            }
            catch (Exception ex)
            {
                pnlMsg.Visible  = true;
                pnlMsg.CssClass = "alert-box alert-err mb-4";
                lblMsg.Text     = "Database error: " + ex.Message;
            }
        }

        protected string GetThumb(string p)
        {
            if (!string.IsNullOrEmpty(p))
                return "<img src='" + ResolveUrl(p) + "' class='tbl-thumb' alt=''/>";
            return "<span class='tbl-thumb-ph'><i class='fas fa-image'></i></span>";
        }

        protected string GetCatBadge(string cat)
        {
            if (string.IsNullOrEmpty(cat)) cat = "General";
            string safe = System.Net.WebUtility.HtmlEncode(cat);
            return $"<span class='cat-badge cat-{safe}'>{safe}</span>";
        }

        protected string GetPinnedBadge(object isPinned)
        {
            bool pinned = isPinned != null && isPinned != System.DBNull.Value && Convert.ToBoolean(isPinned);
            return pinned ? " <span class='pinned-badge'><i class='fas fa-thumbtack'></i> Pinned</span>" : "";
        }

        protected void gv_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            try
            {
                if (e.CommandName == "Del")
                {
                    var row = DB.GetNotice(id);
                    if (row != null)
                    {
                        foreach (string col in new[] { "ImagePath", "PDFPath" })
                        {
                            if (row.Table.Columns.Contains(col) && row[col] != System.DBNull.Value)
                            {
                                string f = Server.MapPath(row[col].ToString());
                                if (File.Exists(f)) File.Delete(f);
                            }
                        }
                    }
                    DB.DeleteNotice(id);
                    pnlMsg.Visible  = true;
                    pnlMsg.CssClass = "alert-box alert-ok mb-4";
                    lblMsg.Text     = "Notice deleted successfully.";
                }
                else if (e.CommandName == "Pin")
                {
                    DB.TogglePin(id);
                    pnlMsg.Visible  = true;
                    pnlMsg.CssClass = "alert-box alert-ok mb-4";
                    lblMsg.Text     = "Pin status updated.";
                }
            }
            catch (Exception ex)
            {
                pnlMsg.Visible  = true;
                pnlMsg.CssClass = "alert-box alert-err mb-4";
                lblMsg.Text     = "Error: " + ex.Message;
            }
            LoadAll();
        }
    }
}
