using System;
using System.Data;
using System.IO;
using System.Web.UI;
namespace DNB
{
    public partial class EditNotice : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminUser"] == null) { Response.Redirect("~/AdminLogin.aspx"); return; }
            string name = Session["AdminName"] as string ?? "Admin";
            lblName.Text = name; lblAv.Text = name.Length > 0 ? name[0].ToString().ToUpper() : "A";
            int id;
            if (!int.TryParse(Request.QueryString["id"], out id) || id <= 0)
            { Response.Redirect("~/AdminDashboard.aspx"); return; }
            hfId.Value = id.ToString();
            if (!IsPostBack)
            {
                try
                {
                    DataRow row = DB.GetNotice(id);
                    if (row == null) { Response.Redirect("~/AdminDashboard.aspx"); return; }
                    lblId.Text    = "#" + id;
                    txtTitle.Text = row["Title"].ToString();
                    txtDesc.Text  = row["Description"].ToString();
                    string cat = row.Table.Columns.Contains("Category") && row["Category"] != DBNull.Value ? row["Category"].ToString() : "Announcements";
                    ddlCategory.SelectedValue = cat;
                    bool pinned = row.Table.Columns.Contains("IsPinned") && row["IsPinned"] != DBNull.Value && Convert.ToBoolean(row["IsPinned"]);
                    chkPinned.Checked = pinned;
                    string img = row.Table.Columns.Contains("ImagePath") && row["ImagePath"] != DBNull.Value ? row["ImagePath"].ToString() : null;
                    if (!string.IsNullOrEmpty(img)) { imgCurr.Src = ResolveUrl(img); pnlImg.Visible = true; }
                    string pdf = row.Table.Columns.Contains("PDFPath") && row["PDFPath"] != DBNull.Value ? row["PDFPath"].ToString() : null;
                    if (!string.IsNullOrEmpty(pdf)) { lnkPDF.HRef = ResolveUrl(pdf); pnlPDF.Visible = true; }
                }
                catch (Exception ex) { pnlErr.Visible = true; lblErr.Text = "Load error: " + ex.Message; }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            int id = Convert.ToInt32(hfId.Value);
            try
            {
                string imgPath = null, pdfPath = null;
                if (fuImage.HasFile)
                {
                    string ext = Path.GetExtension(fuImage.FileName).ToLower();
                    if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".gif")
                    { pnlErr.Visible = true; lblErr.Text = "Only JPG, PNG and GIF images allowed."; return; }
                    if (fuImage.PostedFile.ContentLength > 5 * 1024 * 1024)
                    { pnlErr.Visible = true; lblErr.Text = "Image must be under 5 MB."; return; }
                    string folder = Server.MapPath("~/Images/");
                    if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);
                    string fname = Guid.NewGuid().ToString("N") + ext;
                    fuImage.SaveAs(Path.Combine(folder, fname));
                    imgPath = "~/Images/" + fname;
                }
                if (fuPDF.HasFile)
                {
                    string ext = Path.GetExtension(fuPDF.FileName).ToLower();
                    if (ext != ".pdf" && ext != ".doc" && ext != ".docx")
                    { pnlErr.Visible = true; lblErr.Text = "Only PDF, DOC, DOCX files allowed."; return; }
                    if (fuPDF.PostedFile.ContentLength > 10 * 1024 * 1024)
                    { pnlErr.Visible = true; lblErr.Text = "Document must be under 10 MB."; return; }
                    string folder = Server.MapPath("~/Uploads/");
                    if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);
                    string fname = Guid.NewGuid().ToString("N") + ext;
                    fuPDF.SaveAs(Path.Combine(folder, fname));
                    pdfPath = "~/Uploads/" + fname;
                }
                if (chkRemoveImg.Checked)
                {
                    var old = DB.GetNotice(id);
                    if (old != null && old.Table.Columns.Contains("ImagePath") && old["ImagePath"] != DBNull.Value)
                    { string f = Server.MapPath(old["ImagePath"].ToString()); if (File.Exists(f)) File.Delete(f); }
                    DB.ClearNoticeImage(id); pnlImg.Visible = false;
                }
                if (chkRemovePDF.Checked)
                {
                    var old = DB.GetNotice(id);
                    if (old != null && old.Table.Columns.Contains("PDFPath") && old["PDFPath"] != DBNull.Value)
                    { string f = Server.MapPath(old["PDFPath"].ToString()); if (File.Exists(f)) File.Delete(f); }
                    DB.ClearNoticePDF(id); pnlPDF.Visible = false;
                }
                DB.UpdateNotice(id, txtTitle.Text.Trim(), txtDesc.Text.Trim(), imgPath, pdfPath,
                                ddlCategory.SelectedValue, chkPinned.Checked);
                pnlOk.Visible = true; lblOk.Text = "Notice updated successfully!";
                pnlErr.Visible = false;
                if (!string.IsNullOrEmpty(imgPath)) { imgCurr.Src = ResolveUrl(imgPath); pnlImg.Visible = true; }
                if (!string.IsNullOrEmpty(pdfPath)) { lnkPDF.HRef = ResolveUrl(pdfPath); pnlPDF.Visible = true; }
            }
            catch (Exception ex) { pnlErr.Visible = true; lblErr.Text = "Error: " + ex.Message; }
        }
    }
}
