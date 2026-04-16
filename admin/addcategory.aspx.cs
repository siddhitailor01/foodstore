using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_addcategory : System.Web.UI.Page
{
    string strCon = ConfigurationManager.ConnectionStrings["myCon"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindGrid();
        }
    }

    private void BindGrid()
    {
        using (SqlConnection con = new SqlConnection(strCon))
        {
            // 1. Fetch Data
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM tbl_Categories ORDER BY CategoryID DESC", con))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    GridView1.DataSource = dt;
                    GridView1.DataBind();

                    // 2. Set Total Count Logic
                    lblCount.Text = dt.Rows.Count.ToString();
                }
            }
        }
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        if (txtCategoryName.Text.Trim() == "")
        {
            lblMsg.Text = "<div class='alert alert-warning'>Please enter a category name!</div>";
            return;
        }

        try
        {
            using (SqlConnection con = new SqlConnection(strCon))
            {
                con.Open();

                if (btnAdd.Text == "Add Category")
                {
                    // --- INSERT LOGIC ---

                    // 1. Insert Name & Get ID
                    string query = "INSERT INTO tbl_Categories (CategoryName, CategoryImage) VALUES (@name, ''); SELECT CAST(SCOPE_IDENTITY() as int);";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@name", txtCategoryName.Text.Trim());

                    int newCatID = (int)cmd.ExecuteScalar();

                    if (newCatID > 0 && fuCatImage.HasFile)
                    {
                        SaveImage(newCatID, con);
                    }

                    lblMsg.Text = "<div class='alert alert-success'>Category added successfully!</div>";
                }
                else
                {

                    int editID = Convert.ToInt32(hfCatID.Value);

                    string query = "UPDATE tbl_Categories SET CategoryName = @name WHERE CategoryID = @id";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@name", txtCategoryName.Text.Trim());
                    cmd.Parameters.AddWithValue("@id", editID);
                    cmd.ExecuteNonQuery();

                    if (fuCatImage.HasFile)
                    {
                        SaveImage(editID, con);
                    }

                    lblMsg.Text = "<div class='alert alert-success'>Category updated successfully!</div>";

                    ResetForm();
                }
            }

            BindGrid();
        }
        catch (Exception ex)
        {
            lblMsg.Text = "<div class='alert alert-danger'>Error: " + ex.Message + "</div>";
        }

    }

    private void SaveImage(int catID, SqlConnection con)
    {
        string ext = Path.GetExtension(fuCatImage.FileName);
        string filename = "category_" + catID + ext;
        string savePath = Server.MapPath("~/images/category/") + filename;

        fuCatImage.SaveAs(savePath);

        // Update DB
        string updateQuery = "UPDATE tbl_Categories SET CategoryImage = @img WHERE CategoryID = @id";
        SqlCommand cmdUpdate = new SqlCommand(updateQuery, con);
        cmdUpdate.Parameters.AddWithValue("@img", filename);
        cmdUpdate.Parameters.AddWithValue("@id", catID);
        cmdUpdate.ExecuteNonQuery();
    }

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditCat")
        {
            int rowIndex = Convert.ToInt32(e.CommandArgument);
            int catID = Convert.ToInt32(GridView1.DataKeys[rowIndex].Value);

            Label currentName = (Label)GridView1.Rows[rowIndex].FindControl("lblCatName"); // Assuming simple BoundField is tricky to access directly, let's fetch from DB for reliability

            using (SqlConnection con = new SqlConnection(strCon))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT CategoryName FROM tbl_Categories WHERE CategoryID=@id", con);
                cmd.Parameters.AddWithValue("@id", catID);
                object result = cmd.ExecuteScalar();
                if (result != null)
                {
                    txtCategoryName.Text = result.ToString();
                }
            }
            headerDiv.Attributes["class"] = "card-header-blue bg-primary"; // Adding bg-primary class temporarily or define separate class
            btnAdd.Text = "Update Category";
            btnAdd.CssClass = "btn-submit w-100 bg-primary"; // Change Button Color
            lblHeader.Text = "Edit Category";
            // 3. Set Controls for Edit Mode
            hfCatID.Value = catID.ToString();
            btnAdd.Text = "Update Category";
            btnAdd.CssClass = "btn btn-primary w-100";
            lblHeader.Text = "Edit Food Category";
            btnCancel.Visible = true;
            lblMsg.Text = ""; 
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ResetForm();
    }

    private void ResetForm()
    {
        txtCategoryName.Text = "";
        hfCatID.Value = "0";
        btnAdd.Text = "Add Category";
        btnAdd.CssClass = "btn btn-success w-100";
        lblHeader.Text = "Add Food Category";
        btnCancel.Visible = false;
        lblMsg.Text = "";
    }

    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int catId = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value);

        using (SqlConnection con = new SqlConnection(strCon))
        {

            string query = "DELETE FROM tbl_Categories WHERE CategoryID = @id";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@id", catId);

            con.Open();
            cmd.ExecuteNonQuery();
            BindGrid();
            lblMsg.Text = "<div class='alert alert-danger'>Category deleted.</div>";
        }
    }
}