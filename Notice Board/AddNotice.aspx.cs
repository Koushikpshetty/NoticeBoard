using System;
using System.IO;
using System.Web.UI;
namespace DNB
{
    public partial class AddNotice : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminUser"] == null) { Response.Redirect("~/AdminLogin.aspx"); return; }
            string name = Session["AdminName"] as string ?? "Admin";
            lblName.Text = name;
            lblAv.Text = name.Length > 0 ? name[0].ToString().ToUpper() : "A";
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            try
            {
                string imgPath = null, pdfPath = null;

                // Handle image upload
                if (fuImage.HasFile)
                {
                    string ext = Path.GetExtension(fuImage.FileName).ToLower();
                    if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".gif")
                    { ShowErr("Only JPG, PNG and GIF images are allowed."); return; }
                    if (fuImage.PostedFile.ContentLength > 5 * 1024 * 1024)
                    { ShowErr("Image must be under 5 MB."); return; }
                    string folder = Server.MapPath("~/Images/");
                    if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);
                    string fname = Guid.NewGuid().ToString("N") + ext;
                    fuImage.SaveAs(Path.Combine(folder, fname));
                    imgPath = "~/Images/" + fname;
                }

                // Handle PDF/document upload
                if (fuPDF.HasFile)
                {
                    string ext = Path.GetExtension(fuPDF.FileName).ToLower();
                    if (ext != ".pdf" && ext != ".doc" && ext != ".docx")
                    { ShowErr("Only PDF, DOC, and DOCX files are allowed."); return; }
                    if (fuPDF.PostedFile.ContentLength > 10 * 1024 * 1024)
                    { ShowErr("Document must be under 10 MB."); return; }
                    string folder = Server.MapPath("~/Uploads/");
                    if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);
                    string fname = Guid.NewGuid().ToString("N") + ext;
                    fuPDF.SaveAs(Path.Combine(folder, fname));
                    pdfPath = "~/Uploads/" + fname;
                }

                bool isPinned = chkPinned.Checked;
                string category = ddlCategory.SelectedValue;
                int id = DB.CreateNotice(txtTitle.Text.Trim(), txtDesc.Text.Trim(),
                                         imgPath, pdfPath, category, isPinned,
                                         Session["AdminUser"].ToString());
                pnlOk.Visible = true;
                lblOk.Text = "Notice published successfully! Notice ID #" + id;
                txtTitle.Text = txtDesc.Text = "";
                chkPinned.Checked = false;
                pnlErr.Visible = false;
            }
            catch (Exception ex) { ShowErr("Error: " + ex.Message); }
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtTitle.Text = txtDesc.Text = "";
            pnlOk.Visible = pnlErr.Visible = false;
            chkPinned.Checked = false;
        }

        void ShowErr(string msg) { pnlErr.Visible = true; lblErr.Text = msg; }
    }
}
