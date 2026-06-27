<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="DNB.Home" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head runat="server">
<meta charset="utf-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Digital Notice Board — Official Portal</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
<link rel="stylesheet" href="CSS/site.css"/>
<script>!function(){var t=localStorage.getItem("dnb-theme")||"dark";document.documentElement.setAttribute("data-theme",t)}();</script>
</head>
<body>
<form id="form1" runat="server">

<!-- NAV -->
<nav class="site-nav">
 <div class="container-fluid px-4 d-flex align-items-center justify-content-between flex-wrap gap-2">
 <a class="nav-brand" href="Home.aspx">
 <div class="brand-icon"><i class="fas fa-bullhorn"></i></div>
 <div><div class="brand-title">Digital Notice Board</div><div class="brand-sub">Official Portal</div></div>
 </a>
 <div class="d-flex align-items-center gap-2 flex-wrap">
 <a href="Home.aspx" class="nav-pill active-pill"><i class="fas fa-house me-1"></i>Home</a>
 <a href="StudentLogin.aspx" class="nav-pill"><i class="fas fa-newspaper me-1"></i>Notices</a>
 <a href="StudentRegister.aspx" class="nav-pill"><i class="fas fa-user-plus me-1"></i>Register</a>
 <button type="button" class="theme-toggle" id="modeToggle" title="Toggle light/dark">
 <i class="fas fa-sun"></i>
 </button>
 <a href="AdminLogin.aspx" class="btn-nav-admin ms-1"><i class="fas fa-shield-halved"></i> Admin</a>
 <a href="StudentLogin.aspx" class="btn-nav-student ms-1"><i class="fas fa-graduation-cap"></i> Students</a>
 </div>
 </div>
</nav>

<!-- HERO -->
<section class="hero-section">
 <div class="container py-5" style="position:relative;z-index:1;">
 <div class="row align-items-center g-5">
 <div class="col-lg-6">
 <div class="hero-eyebrow"><i class="fas fa-certificate me-1"></i>Official Institution Portal</div>
 <h1 class="hero-title">Stay <span>Informed.</span><br/>Stay <span>Connected.</span></h1>
 <p class="hero-desc">Your central hub for all official announcements, academic updates, campus events and important notices from the administration.</p>
 <div class="d-flex gap-3 flex-wrap">
 <a href="StudentLogin.aspx" class="cta-primary"><i class="fas fa-graduation-cap"></i> Student Login</a>
 <a href="StudentRegister.aspx" class="cta-secondary"><i class="fas fa-user-plus"></i> Register Free</a>
 </div>
 <div class="mt-4">
 <a href="AdminLogin.aspx" class="admin-tiny-link"><i class="fas fa-shield-halved me-1"></i>Admin Panel</a>
 <span class="mx-2" style="opacity:.2;">|</span>
 <span class="live-dot">Live Updates</span>
 </div>
 </div>
 <div class="col-lg-6">
 <div class="stat-grid">
 <div class="stat-card">
 <i class="fas fa-newspaper mb-2" style="font-size:1.5rem;color:var(--em2);"></i>
 <div class="stat-num"><asp:Label ID="lblNotices" runat="server" Text="0"/></div>
 <div class="stat-lbl">Total Notices</div>
 </div>
 <div class="stat-card">
 <i class="fas fa-users mb-2" style="font-size:1.5rem;color:var(--blue2);"></i>
 <div class="stat-num"><asp:Label ID="lblStudents" runat="server" Text="0"/></div>
 <div class="stat-lbl">Registered Students</div>
 </div>
 <div class="stat-card">
 <i class="fas fa-calendar-day mb-2" style="font-size:1.5rem;color:var(--cyan);"></i>
 <div class="stat-num"><asp:Label ID="lblToday" runat="server" Text="0"/></div>
 <div class="stat-lbl">Posted Today</div>
 </div>
 <div class="stat-card">
 <i class="fas fa-tags mb-2" style="font-size:1.5rem;color:#a78bfa;"></i>
 <div class="stat-num">5</div>
 <div class="stat-lbl">Categories</div>
 </div>
 </div>
 </div>
 </div>
 </div>
</section>

<!-- FEATURES -->
<section class="section-alt py-5">
 <div class="container">
 <div class="text-center mb-5">
 <div class="sec-tag">Platform Features</div>
 <h2 class="sec-title">Everything You Need</h2>
 <p class="sec-desc mt-2">Designed for students and administrators — powerful tools in a clean interface.</p>
 </div>
 <div class="row g-4">
 <div class="col-md-4"><div class="feat-card h-100"><div class="feat-icon fi-a"><i class="fas fa-bolt"></i></div><h5>Instant Updates</h5><p>Notices go live the moment admin publishes them. No delays, no waiting — always current and verified.</p><a href="StudentLogin.aspx" class="small link-teal d-block mt-3">View Notices →</a></div></div>
 <div class="col-md-4"><div class="feat-card h-100"><div class="feat-icon fi-b"><i class="fas fa-envelope"></i></div><h5>Direct Messaging</h5><p>Students can message the admin directly about any notice and receive replies in real time.</p><a href="StudentLogin.aspx" class="small link-teal d-block mt-3">Try it →</a></div></div>
 <div class="col-md-4"><div class="feat-card h-100"><div class="feat-icon fi-c"><i class="fas fa-file-pdf"></i></div><h5>PDF Attachments</h5><p>Admin can attach PDFs and documents to notices. Students can preview and download anytime.</p><a href="StudentRegister.aspx" class="small link-teal d-block mt-3">Register Now →</a></div></div>
 <div class="col-md-4"><div class="feat-card h-100"><div class="feat-icon fi-d"><i class="fas fa-thumbtack"></i></div><h5>Pinned Notices</h5><p>Critical notices can be pinned to the top so students never miss important announcements.</p><a href="StudentLogin.aspx" class="small link-teal d-block mt-3">Explore →</a></div></div>
 <div class="col-md-4"><div class="feat-card h-100"><div class="feat-icon fi-e"><i class="fas fa-filter"></i></div><h5>Smart Filtering</h5><p>Filter notices by category — Exams, Events, Assignments, Placements — and search by keyword.</p><a href="StudentLogin.aspx" class="small link-teal d-block mt-3">Try Search →</a></div></div>
 <div class="col-md-4"><div class="feat-card h-100"><div class="feat-icon fi-f"><i class="fas fa-shield-halved"></i></div><h5>Secure Admin Panel</h5><p>Protected admin dashboard with full control over notices, students and messages — all in one place.</p><a href="AdminLogin.aspx" class="small link-teal d-block mt-3">Admin Login →</a></div></div>
 </div>
 </div>
</section>

<!-- HOW IT WORKS -->
<section class="py-5">
 <div class="container">
 <div class="text-center mb-5">
 <div class="sec-tag">How It Works</div>
 <h2 class="sec-title">Simple. Fast. Reliable.</h2>
 </div>
 <div class="row g-4 justify-content-center">
 <div class="col-md-3 text-center"><div class="step-num step-a">1</div><h6 class="step-title">Register Free</h6><p class="step-desc">Create your student account in seconds</p></div>
 <div class="col-md-3 text-center"><div class="step-num step-b">2</div><h6 class="step-title">Browse Notices</h6><p class="step-desc">View all official notices filtered by category</p></div>
 <div class="col-md-3 text-center"><div class="step-num step-c">3</div><h6 class="step-title">Stay Updated</h6><p class="step-desc">Get all important info before the deadline</p></div>
 <div class="col-md-3 text-center"><div class="step-num step-d">4</div><h6 class="step-title">Message Admin</h6><p class="step-desc">Ask questions directly and get replies</p></div>
 </div>
 </div>
</section>

<!-- CTA -->
<section class="cta-banner">
 <div class="container text-center py-2" style="position:relative;z-index:1;">
 <div class="sec-tag mx-auto">Get Started Today</div>
 <h2 class="cta-title mb-3">Ready to stay informed?</h2>
 <p class="cta-sub mb-4">Create your free student account and access all official notices instantly</p>
 <div class="d-flex gap-3 justify-content-center flex-wrap">
 <a href="StudentRegister.aspx" class="cta-primary"><i class="fas fa-user-plus"></i> Register Free</a>
 <a href="StudentLogin.aspx" class="cta-secondary"><i class="fas fa-graduation-cap"></i> Student Login</a>
 </div>
 </div>
</section>

<!-- FOOTER -->
<footer class="site-footer">
 <div class="container d-flex justify-content-between align-items-center flex-wrap gap-2 py-4">
 <div class="d-flex align-items-center gap-2">
 <div class="brand-icon" style="width:30px;height:30px;font-size:.75rem;border-radius:8px;"><i class="fas fa-bullhorn"></i></div>
 <p class="footer-text">&copy; <%=DateTime.Now.Year%> Digital Notice Board. All Rights Reserved.</p>
 </div>
 <div class="d-flex gap-3">
 <a href="StudentLogin.aspx" class="footer-text"><i class="fas fa-newspaper me-1"></i>Notices</a>
 <a href="AdminLogin.aspx" class="footer-text"><i class="fas fa-shield-halved me-1"></i>Admin</a>
 </div>
 </div>
</footer>
</form>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
<script src="Scripts/site.js"></script>
</body></html>
