<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Messages.aspx.cs" Inherits="DNB.Messages" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head runat="server">
<meta charset="utf-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Message Center — Digital Notice Board</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
<link rel="stylesheet" href="CSS/site.css"/>
<style>
.msg-from{font-size:.9rem;font-weight:700;color:var(--text)}
.msg-subject{font-size:.82rem;color:var(--em2);font-weight:700;margin-top:.2rem}
.msg-date{font-size:.72rem;color:var(--text3);font-weight:600}
.msg-text{font-size:.88rem;color:var(--text2);line-height:1.65;background:rgba(255,255,255,.025);border-radius:var(--r-sm);padding:.75rem 1rem}
.msg-reply-box{background:linear-gradient(135deg,rgba(16,185,129,.07),rgba(6,182,212,.05));border:1px solid rgba(16,185,129,.2);border-radius:var(--r-sm);padding:.85rem 1rem;margin-top:.5rem}
.btn-reply{display:inline-flex;align-items:center;gap:.4rem;background:var(--em-dim);border:1px solid rgba(16,185,129,.25);color:var(--em2);font-size:.78rem;font-weight:700;padding:.38rem .85rem;border-radius:8px;cursor:pointer;transition:all .2s;font-family:'Outfit',sans-serif}
.btn-reply:hover{background:rgba(16,185,129,.2);transform:translateY(-1px)}
</style>
<script>!function(){var t=localStorage.getItem("dnb-theme")||"dark";document.documentElement.setAttribute("data-theme",t)}();</script>
</head>
<body>
<form id="form1" runat="server">
<asp:HiddenField ID="hfMsgId" runat="server"/>
<div class="adm-layout">
 <aside class="adm-sidebar" id="sidebar">
 <div class="sidebar-brand">
 <div class="brand-icon" style="width:36px;height:36px;font-size:.85rem;"><i class="fas fa-bullhorn"></i></div>
 <div><div style="font-size:.9rem;font-weight:800;color:#fff;">Notice Board</div><div style="font-size:.58rem;color:rgba(255,255,255,.35);letter-spacing:2px;text-transform:uppercase;">Admin Panel</div></div>
 </div>
 <nav class="sidebar-nav">
 <div class="nav-section">Main</div>
 <a href="AdminDashboard.aspx" class="nav-link-item"><span class="nav-ico"><i class="fas fa-gauge-high"></i></span>Dashboard</a>
 <a href="AddNotice.aspx" class="nav-link-item"><span class="nav-ico"><i class="fas fa-circle-plus"></i></span>Add Notice</a>
 <a href="Messages.aspx" class="nav-link-item active"><span class="nav-ico"><i class="fas fa-envelope"></i></span>Message Center</a>
 <a href="Students.aspx" class="nav-link-item"><span class="nav-ico"><i class="fas fa-users"></i></span>Manage Students</a>
 <div class="nav-section mt-2">System</div>
 <a href="Home.aspx" target="_blank" class="nav-link-item"><span class="nav-ico"><i class="fas fa-arrow-up-right-from-square"></i></span>View Site</a>
 <a href="Logout.aspx" class="nav-link-item nav-link-red"><span class="nav-ico"><i class="fas fa-right-from-bracket"></i></span>Logout</a>
 </nav>
 <div class="sidebar-user">
 <div class="user-av"><asp:Label ID="lblAv" runat="server" Text="A"/></div>
 <div><div class="user-name"><asp:Label ID="lblName" runat="server" Text="Admin"/></div><div class="user-role">Administrator</div></div>
 </div>
 </aside>

 <div class="adm-main-area">
 <div class="adm-topbar">
 <div class="d-flex align-items-center gap-3">
 <button type="button" class="sidebar-toggle" onclick="document.getElementById('sidebar').classList.toggle('open')"><i class="fas fa-bars"></i></button>
 <div>
 <div class="page-title"><i class="fas fa-envelope me-2 text-amber"></i>Message Center</div>
 <div class="page-sub">View and reply to student messages</div>
 </div>
 </div>
 <span class="time-chip" id="adminClock"><i class="fas fa-clock me-1"></i>Loading...</span>
 <button type="button" class="theme-toggle" id="modeToggle" title="Toggle mode"><i class="fas fa-sun"></i></button>
 </div>

 <div class="adm-content-body">
 <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert-box mb-4">
 <i class="fas fa-circle-check me-2"></i><asp:Label ID="lblAlert" runat="server"/>
 </asp:Panel>

 <div class="row g-3 mb-4">
 <div class="col-sm-4">
 <div class="stat-tile stat-c">
 <div class="st-icon"><i class="fas fa-envelope"></i></div>
 <div><div class="st-num"><asp:Label ID="lblTotal" runat="server" Text="0"/></div><div class="st-lbl">Total Messages</div></div>
 </div>
 </div>
 <div class="col-sm-4">
 <div class="stat-tile stat-d">
 <div class="st-icon"><i class="fas fa-clock"></i></div>
 <div><div class="st-num"><asp:Label ID="lblPending" runat="server" Text="0"/></div><div class="st-lbl">Pending Replies</div></div>
 </div>
 </div>
 <div class="col-sm-4">
 <div class="stat-tile stat-b">
 <div class="st-icon"><i class="fas fa-check-double"></i></div>
 <div><div class="st-num"><asp:Label ID="lblReplied" runat="server" Text="0"/></div><div class="st-lbl">Replied</div></div>
 </div>
 </div>
 </div>

 <div class="data-panel">
 <div class="data-panel-head dark-head">
 <h5 style="color:#fff;margin:0;"><i class="fas fa-inbox me-2 text-amber"></i>Student Messages</h5>
 <span class="live-dot" style="font-size:.72rem;">Inbox</span>
 </div>
 <div class="p-3">
 <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
 <div class="empty-state">
 <div class="empty-icon"><i class="fas fa-envelope-open"></i></div>
 <div class="empty-title">No Messages Yet</div>
 <p class="empty-sub">Students haven't sent any messages yet.</p>
 </div>
 </asp:Panel>

 <asp:Repeater ID="rptMessages" runat="server">
 <ItemTemplate>
 <div class='msg-card <%# (Eval("ReplyText") == DBNull.Value || string.IsNullOrEmpty(Eval("ReplyText") as string)) ? "unread" : "replied" %> mb-3'>
 <div class="d-flex justify-content-between align-items-start flex-wrap gap-2 mb-3">
 <div>
 <div class="msg-from"><i class="fas fa-user-graduate me-1" style="color:var(--em2);"></i><%# Server.HtmlEncode(Eval("StudentName").ToString()) %> <span style="color:var(--text3);font-weight:400;font-size:.8rem;">@<%# Eval("Username") %></span></div>
 <div class="msg-subject"><i class="fas fa-tag me-1" style="font-size:.7rem;"></i><%# Server.HtmlEncode(Eval("Subject").ToString()) %></div>
 <%# Eval("NoticeTitle") != DBNull.Value ? "<div class='msg-date mt-1'><i class='fas fa-newspaper me-1'></i>Re: <strong style='color:var(--text2);'>" + Server.HtmlEncode(Eval("NoticeTitle").ToString()) + "</strong></div>" : "" %>
 </div>
 <div class="text-end">
 <div class="msg-date"><i class="fas fa-calendar me-1"></i><%# DataBinder.Eval(Container.DataItem, "SentDate", "{0:MMM dd, yyyy HH:mm}") %></div>
 <div class="mt-1">
 <%# (Eval("ReplyText") == DBNull.Value || string.IsNullOrEmpty(Eval("ReplyText") as string))
 ? "<span class='status-pill status-pending'>⏳ Pending</span>"
 : "<span class='status-pill status-replied'> Replied</span>" %>
 </div>
 </div>
 </div>
 <div class="msg-text mb-3"><%# Server.HtmlEncode(Eval("MessageText").ToString()) %></div>
 <%# Eval("ReplyText") != DBNull.Value && !string.IsNullOrEmpty(Eval("ReplyText") as string)
 ? "<div class='msg-reply-box'><div class='reply-header'><i class='fas fa-reply'></i>Admin Reply — " + DataBinder.Eval(Container.DataItem, "ReplyDate", "{0:MMM dd, yyyy}") + "</div><div class='msg-text'>" + Server.HtmlEncode(Eval("ReplyText").ToString()) + "</div></div>"
 : "" %>
 <button type="button" class="btn-reply mt-1"
 onclick="openReplyModal('<%# Eval("MessageID") %>')">
 <i class="fas fa-reply me-1"></i><%# (Eval("ReplyText") == DBNull.Value || string.IsNullOrEmpty(Eval("ReplyText") as string)) ? "Reply" : "Edit Reply" %>
 </button>
 </div>
 </ItemTemplate>
 </asp:Repeater>
 </div>
 </div>
 </div>
 </div>
</div>

<!-- Reply Modal -->
<div class="modal fade" id="replyModal" tabindex="-1">
 <div class="modal-dialog modal-dialog-centered">
 <div class="modal-content">
 <div class="modal-header">
 <h5 class="modal-title"><i class="fas fa-reply me-2" style="color:var(--em2);"></i>Reply to Student</h5>
 <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
 </div>
 <div class="modal-body p-4">
 <asp:Panel ID="pnlReplyErr" runat="server" Visible="false" CssClass="alert-box alert-err mb-3">
 <asp:Label ID="lblReplyErr" runat="server"/>
 </asp:Panel>
 <label class="form-lbl">Your Reply</label>
 <asp:TextBox ID="txtReply" runat="server" CssClass="form-inp" TextMode="MultiLine" Rows="5" placeholder="Type your reply to the student..."/>
 <asp:RequiredFieldValidator runat="server" ControlToValidate="txtReply" ErrorMessage="Reply cannot be empty" CssClass="val-msg" Display="Dynamic" ValidationGroup="reply"/>
 </div>
 <div class="modal-footer">
 <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">Cancel</button>
 <asp:Button ID="btnSendReply" runat="server" Text="Send Reply" CssClass="btn-submit btn-teal" OnClick="btnSendReply_Click" ValidationGroup="reply"/>
 </div>
 </div>
 </div>
</div>

</form>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
<script src="Scripts/site.js"></script>
<script>
var _replyModal;
function openReplyModal(msgId) {
 document.getElementById('<%=hfMsgId.ClientID%>').value = msgId;
 document.getElementById('<%=txtReply.ClientID%>').value = '';
 if (!_replyModal) _replyModal = new bootstrap.Modal(document.getElementById('replyModal'));
 _replyModal.show();
}
<%if(ViewState["showReplyModal"] != null && (bool)ViewState["showReplyModal"]){%>
window.addEventListener('load', function(){
 if(!_replyModal) _replyModal = new bootstrap.Modal(document.getElementById('replyModal'));
 _replyModal.show();
});
<%}%>
</script>
</body></html>
