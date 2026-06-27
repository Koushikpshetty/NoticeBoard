<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="DNB.AdminDashboard" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head runat="server">
<meta charset="utf-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Admin Dashboard — Digital Notice Board</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
<link rel="stylesheet" href="CSS/site.css"/>
<style>
.btn-pin{display:inline-flex;align-items:center;gap:.3rem;background:var(--amber-dim);border:1px solid rgba(245,158,11,.25);color:#fcd34d;font-size:.78rem;font-weight:700;padding:.38rem .7rem;border-radius:6px;cursor:pointer;transition:all .18s}
.btn-pin:hover{background:rgba(245,158,11,.2)}
.btn-dl{display:inline-flex;align-items:center;gap:.3rem;background:var(--rose-dim);border:1px solid rgba(244,63,94,.25);color:#fb7185;font-size:.78rem;font-weight:700;padding:.38rem .7rem;border-radius:6px;cursor:pointer;transition:all .18s}
.btn-dl:hover{background:rgba(244,63,94,.2)}
.thumb-sm{width:44px;height:34px;border-radius:6px;object-fit:cover;border:1px solid var(--border)}
.no-img{width:44px;height:34px;border-radius:6px;background:var(--glass);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;color:var(--text3);font-size:.7rem}
.quick-actions{display:flex;gap:.75rem;flex-wrap:wrap;margin-bottom:1.75rem}
.quick-action-card{flex:1;min-width:160px;background:var(--glass);border:1px solid var(--border2);border-radius:var(--r);padding:1rem 1.25rem;display:flex;align-items:center;gap:.85rem;cursor:pointer;transition:all .2s;text-decoration:none}
.quick-action-card:hover{border-color:var(--em);transform:translateY(-2px)}
.qa-icon{width:38px;height:38px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:.95rem;flex-shrink:0}
</style>
<script>!function(){var t=localStorage.getItem("dnb-theme")||"dark";document.documentElement.setAttribute("data-theme",t)}();</script>
</head>
<body>
<form id="form1" runat="server">
<div class="adm-layout">

 <!-- SIDEBAR -->
 <aside class="adm-sidebar" id="sidebar">
 <div class="sidebar-brand">
 <div class="brand-icon" style="width:36px;height:36px;font-size:.85rem;"><i class="fas fa-bullhorn"></i></div>
 <div><div style="font-size:.9rem;font-weight:800;color:#fff;">Notice Board</div><div style="font-size:.58rem;color:rgba(255,255,255,.35);letter-spacing:2px;text-transform:uppercase;">Admin Panel</div></div>
 </div>
 <nav class="sidebar-nav">
 <div class="nav-section">Main</div>
 <a href="AdminDashboard.aspx" class="nav-link-item active"><span class="nav-ico"><i class="fas fa-gauge-high"></i></span>Dashboard</a>
 <a href="AddNotice.aspx" class="nav-link-item"><span class="nav-ico"><i class="fas fa-circle-plus"></i></span>Add Notice</a>
 <a href="Messages.aspx" class="nav-link-item">
 <span class="nav-ico"><i class="fas fa-envelope"></i></span>Message Center
 <asp:Label ID="lblMsgBadge" runat="server" CssClass="nav-badge" Visible="false"/>
 </a>
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

 <!-- MAIN -->
 <div class="adm-main-area">
 <div class="adm-topbar">
 <div class="d-flex align-items-center gap-3">
 <button type="button" class="sidebar-toggle" onclick="document.getElementById('sidebar').classList.toggle('open')"><i class="fas fa-bars"></i></button>
 <div>
 <div class="page-title"><i class="fas fa-gauge-high me-2 text-amber"></i>Dashboard</div>
 <div class="page-sub">Manage all notices and view statistics</div>
 </div>
 </div>
 <div class="d-flex gap-2 align-items-center flex-wrap">
 <span class="time-chip" id="adminClock"><i class="fas fa-clock me-1"></i>Loading...</span>
 <button type="button" class="theme-toggle" id="modeToggle" title="Toggle mode"><i class="fas fa-sun"></i></button>
 <a href="AddNotice.aspx" class="btn-nav-admin"><i class="fas fa-plus"></i> Add Notice</a>
 </div>
 </div>

 <div class="adm-content-body">
 <asp:Panel ID="pnlMsg" runat="server" Visible="false" CssClass="alert-box mb-4">
 <i class="fas fa-circle-check me-2"></i><asp:Label ID="lblMsg" runat="server"/>
 </asp:Panel>

 <!-- QUICK ACTIONS -->
 <div class="quick-actions">
 <a href="AddNotice.aspx" class="quick-action-card">
 <div class="qa-icon" style="background:var(--em-dim);color:var(--em2);"><i class="fas fa-plus"></i></div>
 <div><div style="font-size:.88rem;font-weight:700;color:#fff;">New Notice</div><div style="font-size:.72rem;color:var(--text3);">Create &amp; publish</div></div>
 </a>
 <a href="Messages.aspx" class="quick-action-card">
 <div class="qa-icon" style="background:var(--blue-dim);color:var(--blue2);"><i class="fas fa-envelope"></i></div>
 <div><div style="font-size:.88rem;font-weight:700;color:#fff;">Messages</div><div style="font-size:.72rem;color:var(--text3);">Reply to students</div></div>
 </a>
 <a href="Students.aspx" class="quick-action-card">
 <div class="qa-icon" style="background:var(--violet-dim);color:#a78bfa;"><i class="fas fa-users"></i></div>
 <div><div style="font-size:.88rem;font-weight:700;color:#fff;">Students</div><div style="font-size:.72rem;color:var(--text3);">Manage accounts</div></div>
 </a>
 <a href="Home.aspx" target="_blank" class="quick-action-card">
 <div class="qa-icon" style="background:var(--amber-dim);color:#fcd34d;"><i class="fas fa-eye"></i></div>
 <div><div style="font-size:.88rem;font-weight:700;color:#fff;">Preview Site</div><div style="font-size:.72rem;color:var(--text3);">Student view</div></div>
 </a>
 </div>

 <!-- STATS ROW -->
 <div class="row g-3 mb-4">
 <div class="col-xl-2 col-sm-4">
 <div class="stat-tile stat-a">
 <div class="st-icon"><i class="fas fa-newspaper"></i></div>
 <div><div class="st-num"><asp:Label ID="lblTotal" runat="server" Text="0"/></div><div class="st-lbl">Total Notices</div></div>
 </div>
 </div>
 <div class="col-xl-2 col-sm-4">
 <div class="stat-tile stat-b">
 <div class="st-icon"><i class="fas fa-calendar-day"></i></div>
 <div><div class="st-num"><asp:Label ID="lblToday" runat="server" Text="0"/></div><div class="st-lbl">Today</div></div>
 </div>
 </div>
 <div class="col-xl-2 col-sm-4">
 <div class="stat-tile stat-c">
 <div class="st-icon"><i class="fas fa-users"></i></div>
 <div><div class="st-num"><asp:Label ID="lblStudents" runat="server" Text="0"/></div><div class="st-lbl">Students</div></div>
 </div>
 </div>
 <div class="col-xl-2 col-sm-4">
 <div class="stat-tile stat-d">
 <div class="st-icon"><i class="fas fa-envelope"></i></div>
 <div><div class="st-num"><asp:Label ID="lblMessages" runat="server" Text="0"/></div><div class="st-lbl">Messages</div></div>
 </div>
 </div>
 <div class="col-xl-2 col-sm-4">
 <div class="stat-tile stat-e">
 <div class="st-icon"><i class="fas fa-clock-rotate-left"></i></div>
 <div><div class="st-num"><asp:Label ID="lblPending" runat="server" Text="0"/></div><div class="st-lbl">Pending</div></div>
 </div>
 </div>
 <div class="col-xl-2 col-sm-4">
 <div class="stat-tile stat-a">
 <div class="st-icon"><i class="fas fa-image"></i></div>
 <div><div class="st-num"><asp:Label ID="lblImages" runat="server" Text="0"/></div><div class="st-lbl">With Images</div></div>
 </div>
 </div>
 </div>

 <!-- NOTICES TABLE -->
 <div class="data-panel">
 <div class="data-panel-head dark-head">
 <h5 style="color:#fff;margin:0;"><i class="fas fa-table-list me-2 text-amber"></i>All Notices</h5>
 <div class="d-flex gap-2 align-items-center">
 <span class="live-dot" style="font-size:.72rem;">Live</span>
 <a href="AddNotice.aspx" class="btn-nav-admin" style="font-size:.8rem;padding:.35rem .9rem;"><i class="fas fa-plus"></i> New</a>
 </div>
 </div>
 <div class="table-responsive">
 <asp:GridView ID="gv" runat="server" CssClass="data-table w-100" AutoGenerateColumns="false"
 GridLines="None" DataKeyNames="NoticeID" OnRowCommand="gv_RowCommand"
 EmptyDataText="No notices yet. Click Add Notice to create one.">
 <EmptyDataRowStyle CssClass="text-center p-5"/>
 <Columns>
 <asp:TemplateField HeaderText="#" ItemStyle-Width="40">
  <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
 </asp:TemplateField>
 <asp:TemplateField HeaderText="Image" ItemStyle-Width="60">
 <ItemTemplate><%# GetThumb(Eval("ImagePath") as string) %></ItemTemplate>
 </asp:TemplateField>
 <asp:TemplateField HeaderText="Title">
 <ItemTemplate>
 <span style="font-weight:700;color:var(--text);"><%# Server.HtmlEncode(Eval("Title").ToString()) %></span>
 <%# GetPinnedBadge(Eval("IsPinned")) %>
 </ItemTemplate>
 </asp:TemplateField>
 <asp:TemplateField HeaderText="Category">
 <ItemTemplate><%# GetCatBadge(Eval("Category").ToString()) %></ItemTemplate>
 </asp:TemplateField>
 <asp:BoundField DataField="UploadDate" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" ItemStyle-Width="110"/>
 <asp:TemplateField HeaderText="Actions" ItemStyle-Width="220">
 <ItemTemplate>
 <a href='<%# "EditNotice.aspx?id="+Eval("NoticeID") %>' class="btn-ed"><i class="fas fa-pen"></i> Edit</a>
 <asp:LinkButton runat="server" CommandName="Pin" CommandArgument='<%# Eval("NoticeID") %>' CssClass="btn-pin" ToolTip="Toggle Pin">
 <i class="fas fa-thumbtack"></i>
 </asp:LinkButton>
 <asp:LinkButton runat="server" CommandName="Del" CommandArgument='<%# Eval("NoticeID") %>'
 CssClass="btn-dl" OnClientClick="return confirm('Delete this notice permanently?');">
 <i class="fas fa-trash"></i>
 </asp:LinkButton>
 </ItemTemplate>
 </asp:TemplateField>
 </Columns>
 </asp:GridView>
 </div>
 </div>

 </div>
 </div>
</div>
</form>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
<script src="Scripts/site.js"></script>
</body></html>
