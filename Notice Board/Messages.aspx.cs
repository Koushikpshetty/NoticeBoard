using System;
using System.Web.UI;
using System.Web.UI.WebControls;
namespace DNB
{
    public partial class Messages : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminUser"] == null) { Response.Redirect("~/AdminLogin.aspx"); return; }
            string name = Session["AdminName"] as string ?? "Admin";
            lblName.Text = name; lblAv.Text = name.Length > 0 ? name[0].ToString().ToUpper() : "A";
            if (!IsPostBack) LoadMessages();
        }

        void LoadMessages()
        {
            int total = DB.CountMessages();
            int pending = DB.CountPendingReplies();
            lblTotal.Text   = total.ToString();
            lblPending.Text = pending.ToString();
            lblReplied.Text = (total - pending).ToString();
            var dt = DB.GetAllMessages();
            if (dt.Rows.Count == 0) { pnlEmpty.Visible = true; rptMessages.Visible = false; }
            else { pnlEmpty.Visible = false; rptMessages.Visible = true; rptMessages.DataSource = dt; rptMessages.DataBind(); }
        }

        protected void rptMessages_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "OpenReply")
            {
                hfMsgId.Value = e.CommandArgument.ToString();
                ViewState["showReplyModal"] = true;
                txtReply.Text = "";
                pnlReplyErr.Visible = false;
                LoadMessages();
            }
        }

        protected void btnSendReply_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) { ViewState["showReplyModal"] = true; return; }
            int msgId;
            if (!int.TryParse(hfMsgId.Value, out msgId) || msgId <= 0)
            { pnlReplyErr.Visible = true; lblReplyErr.Text = "Invalid message selected."; ViewState["showReplyModal"] = true; return; }
            try
            {
                DB.ReplyMessage(msgId, txtReply.Text.Trim());
                ViewState["showReplyModal"] = null;
                pnlAlert.Visible = true;
                pnlAlert.CssClass = "alert-box alert-ok mb-4";
                lblAlert.Text = "Reply sent successfully!";
                txtReply.Text = "";
                hfMsgId.Value = "";
                LoadMessages();
            }
            catch (Exception ex)
            {
                pnlReplyErr.Visible = true;
                lblReplyErr.Text = "Error sending reply: " + ex.Message;
                ViewState["showReplyModal"] = true;
            }
        }
    }
}
