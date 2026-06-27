<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Students.aspx.cs" Inherits="DNB.Students" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head runat="server">
<meta charset="utf-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Manage Students — Digital Notice Board</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
<link rel="stylesheet" href="CSS/site.css"/>
<style>
.student-av{width:34px;height:34px;border-radius:10px;background:linear-gradient(135deg,var(--blue),var(--violet));display:flex;align-items:center;justify-content:center;font-weight:800;font-size:.85rem;color:#fff;flex-shrink:0}
</style>
<script>!function(){var t=localStorage.getItem("dnb-theme")||"dark";document.documentElement.setAttribute("data-theme",t)}();</script>
</head>
<body>
<form id="form1" runat="server">
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
 <a href="Messages.aspx" class="nav-link-item"><span class="nav-ico"><i class="fas fa-envelope"></i></span>Message Center</a>
 <a href="Students.aspx" class="nav-link-item active"><span class="nav-ico"><i class="fas fa-users"></i></span>Manage Students</a>
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
 <div class="page-title"><i class="fas fa-users me-2 text-amber"></i>Manage Students</div>
 <div class="page-sub">View all registered student accounts</div>
 </div>
 </div>
 <span class="time-chip" id="adminClock"><i class="fas fa-clock me-1"></i>Loading...</span>
 <button type="button" class="theme-toggle" id="modeToggle" title="Toggle mode"><i class="fas fa-sun"></i></button>
 </div>

 <div class="adm-content-body">
 <div class="data-panel">
 <div class="data-panel-head dark-head">
 <h5 style="color:#fff;margin:0;"><i class="fas fa-graduation-cap me-2" style="color:var(--blue2);"></i>Registered Students
 <span style="background:var(--blue-dim);border:1px solid rgba(59,130,246,.25);color:var(--blue2);font-size:.72rem;font-weight:700;padding:.18rem .65rem;border-radius:50px;margin-left:.5rem;">
 <asp:Label ID="lblCount" runat="server" Text="0"/>
 </span>
 </h5>
 <span class="live-dot" style="font-size:.72rem;">Active</span>
 </div>
 <div class="table-responsive">
 <asp:GridView ID="gv" runat="server" CssClass="data-table w-100" AutoGenerateColumns="false"
 GridLines="None" EmptyDataText="No students registered yet.">
 <EmptyDataRowStyle CssClass="text-center p-5"/>
 <Columns>
 <asp:BoundField DataField="StudentID" HeaderText="#" ItemStyle-Width="50"/>
 <asp:TemplateField HeaderText="Student">
 <ItemTemplate>
 <div class="d-flex align-items-center gap-2">
 <div class="student-av"><%# Eval("FullName").ToString().Length > 0 ? Eval("FullName").ToString()[0].ToString().ToUpper() : "S" %></div>
 <div>
 <div style="font-weight:700;color:var(--text);"><%# Server.HtmlEncode(Eval("FullName").ToString()) %></div>
 <div class="stu-email">@<%# Eval("Username") %></div>
 </div>
 </div>
 </ItemTemplate>
 </asp:TemplateField>
 <asp:TemplateField HeaderText="Email">
 <ItemTemplate>
 <span class="stu-email"><%# Server.HtmlEncode(Eval("Email").ToString()) %></span>
 </ItemTemplate>
 </asp:TemplateField>
 <asp:TemplateField HeaderText="Registered" ItemStyle-Width="130">
 <ItemTemplate>
 <span class="stu-date"><i class="fas fa-calendar me-1"></i><%# DataBinder.Eval(Container.DataItem, "CreatedDate", "{0:MMM dd, yyyy}") %></span>
 </ItemTemplate>
 </asp:TemplateField>
 <asp:TemplateField HeaderText="Status" ItemStyle-Width="100">
 <ItemTemplate>
 <span class="status-pill status-active"><i class="fas fa-circle" style="font-size:.5rem;"></i>Active</span>
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
