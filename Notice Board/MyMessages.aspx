<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyMessages.aspx.cs" Inherits="DNB.MyMessages" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head runat="server">
<meta charset="utf-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>My Messages — Digital Notice Board</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
<link rel="stylesheet" href="CSS/site.css"/>
<style>
.msg-subject{font-size:.88rem;color:var(--em2);font-weight:700}
.msg-date{font-size:.72rem;color:var(--text3);font-weight:600}
.msg-text{font-size:.88rem;color:var(--text2);line-height:1.65;background:rgba(255,255,255,.03);border-radius:var(--r-sm);padding:.75rem 1rem;border:1px solid var(--border)}
.reply-card-head{display:flex;justify-content:space-between;align-items:flex-start;flex-wrap:wrap;gap:.75rem;margin-bottom:1rem}
.reply-card-body{}
.alert-info{background:var(--amber-dim);border:1px solid rgba(245,158,11,.25);color:#fcd34d;border-radius:var(--r-sm)}
</style>
<script>!function(){var t=localStorage.getItem("dnb-theme")||"dark";document.documentElement.setAttribute("data-theme",t)}();</script>
</head>
<body>
<form id="form1" runat="server">

<nav class="site-nav">
 <div class="container-fluid px-4 d-flex align-items-center justify-content-between flex-wrap gap-2">
 <a class="nav-brand" href="StudentDashboard.aspx">
 <div class="brand-icon"><i class="fas fa-bullhorn"></i></div>
 <div><div class="brand-title">Digital Notice Board</div><div class="brand-sub">Student Portal</div></div>
 </a>
 <div class="d-flex align-items-center gap-2">
 <a href="StudentDashboard.aspx" class="nav-pill"><i class="fas fa-home me-1"></i>Dashboard</a>
 <a href="Logout.aspx" class="btn-nav-admin"><i class="fas fa-right-from-bracket"></i> Logout</a>
 </div>
 </div>
</nav>

<div class="stu-banner" style="position:relative;overflow:hidden;">
 <div class="container py-3 text-center" style="position:relative;z-index:1;">
 <h2 class="stu-welcome"><i class="fas fa-envelope me-2" style="color:var(--em2);"></i>My Messages</h2>
 <p class="stu-sub">Your messages and replies from the administration</p>
 </div>
</div>

<div class="container py-4">
 <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
 <div class="empty-state">
 <div class="empty-icon"><i class="fas fa-envelope-open"></i></div>
 <div class="empty-title">No Messages Sent</div>
 <p class="empty-sub">You haven't sent any messages yet.<br/>Use the "Message Admin" button on any notice card.</p>
 <a href="StudentDashboard.aspx" class="btn-submit btn-teal mt-3" style="display:inline-flex;padding:.65rem 1.5rem;font-size:.88rem;">
 <i class="fas fa-arrow-left me-1"></i> Back to Notices
 </a>
 </div>
 </asp:Panel>

 <asp:Repeater ID="rpt" runat="server">
 <ItemTemplate>
 <div class='reply-card mb-3 <%# (Eval("ReplyText") != DBNull.Value && !string.IsNullOrEmpty(Eval("ReplyText") as string)) ? "replied" : "" %>'>
 <div class="reply-card-head">
 <div>
 <div class="msg-subject"><i class="fas fa-tag me-1" style="font-size:.72rem;"></i><%# Server.HtmlEncode(Eval("Subject").ToString()) %></div>
 <%# Eval("NoticeTitle") != DBNull.Value ? "<div class='msg-date mt-1'><i class='fas fa-newspaper me-1'></i>Re: <strong style='color:var(--text2);'>" + Server.HtmlEncode(Eval("NoticeTitle").ToString()) + "</strong></div>" : "<div class='msg-date mt-1'>General Query</div>" %>
 </div>
 <div class="text-end">
 <div class="msg-date"><i class="fas fa-calendar me-1"></i><%# DataBinder.Eval(Container.DataItem, "SentDate", "{0:MMM dd, yyyy HH:mm}") %></div>
 <div class="mt-1">
 <%# (Eval("ReplyText") == DBNull.Value || string.IsNullOrEmpty(Eval("ReplyText") as string))
 ? "<span class='status-pill status-pending'>⏳ Awaiting Reply</span>"
 : "<span class='status-pill status-replied'><i class='fas fa-check me-1'></i>Replied</span>" %>
 </div>
 </div>
 </div>
 <div class="reply-card-body">
 <div class="mb-3">
 <div style="font-size:.72rem;font-weight:800;color:var(--text3);text-transform:uppercase;letter-spacing:.5px;margin-bottom:.5rem;"><i class="fas fa-comment me-1"></i>Your Message</div>
 <div class="msg-text"><%# Server.HtmlEncode(Eval("MessageText").ToString()) %></div>
 </div>
 <%# Eval("ReplyText") != DBNull.Value && !string.IsNullOrEmpty(Eval("ReplyText") as string)
 ? "<div><div style='font-size:.72rem;font-weight:800;color:var(--em2);text-transform:uppercase;letter-spacing:.5px;margin-bottom:.5rem;'><i class='fas fa-reply me-1'></i>Admin Reply — " + DataBinder.Eval(Container.DataItem, "ReplyDate", "{0:MMM dd, yyyy}") + "</div><div style='background:linear-gradient(135deg,rgba(16,185,129,.07),rgba(6,182,212,.05));border:1px solid rgba(16,185,129,.2);border-radius:var(--r-sm);padding:.85rem 1rem;font-size:.88rem;color:var(--text2);line-height:1.65;'>" + Server.HtmlEncode(Eval("ReplyText").ToString()) + "</div></div>"
 : "<div class='alert-info p-3' style='font-size:.83rem;display:flex;align-items:center;gap:.5rem;'><i class='fas fa-clock'></i>Your message has been received. The admin will reply soon.</div>" %>
 </div>
 </div>
 </ItemTemplate>
 </asp:Repeater>

 <div class="text-center mt-4">
 <a href="StudentDashboard.aspx" class="btn-outline-custom"><i class="fas fa-arrow-left me-1"></i>Back to Notices</a>
 </div>
</div>

<footer class="site-footer mt-5">
 <div class="container d-flex justify-content-between align-items-center flex-wrap gap-2 py-4">
 <p class="footer-text">&copy; <%=DateTime.Now.Year%> Digital Notice Board.</p>
 <a href="StudentDashboard.aspx" class="footer-text"><i class="fas fa-home me-1"></i>Dashboard</a>
 </div>
</footer>
</form>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
<script src="Scripts/site.js"></script>
</body></html>
