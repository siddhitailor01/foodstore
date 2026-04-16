using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_addcity : System.Web.UI.Page
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
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM tbl_Cities ORDER BY CityID DESC", con))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    GridView1.DataSource = dt;
                    GridView1.DataBind();
                }
            }
        }
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        if (txtCityName.Text.Trim() == "")
        {
            lblMsg.Text = "<div class='alert alert-warning'>Please enter a city name!</div>";
            return;
        }

        try
        {
            using (SqlConnection con = new SqlConnection(strCon))
            {
                string query = "INSERT INTO tbl_Cities (CityName) VALUES (@name)";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@name", txtCityName.Text.Trim());

                con.Open();
                cmd.ExecuteNonQuery();

                txtCityName.Text = "";
                lblMsg.Text = "<div class='alert alert-success'>City added successfully!</div>";
                BindGrid();
            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = "<div class='alert alert-danger'>Error: " + ex.Message + "</div>";
        }
    }

    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int cityId = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value);

        using (SqlConnection con = new SqlConnection(strCon))
        {
            string query = "DELETE FROM tbl_Cities WHERE CityID = @id";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@id", cityId);

            con.Open();
            cmd.ExecuteNonQuery();

            // Refresh List
            BindGrid();
        }
    }
}