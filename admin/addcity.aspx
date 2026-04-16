<%@ Page Title="Manage Cities" Language="C#" MasterPageFile="~/admin/AdminMaster.master" AutoEventWireup="true" CodeFile="addcity.aspx.cs" Inherits="admin_addcity" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        /* --- CARD STYLING --- */
        .admin-card {
            background: #fff;
            border-radius: 15px;
            border: none;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            margin-bottom: 20px;
        }

        /* --- HEADER (Blue Theme) --- */
        .card-header-blue {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            padding: 20px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .card-header-blue h5 { margin: 0; font-weight: 600; letter-spacing: 0.5px; font-size: 16px; }

        /* --- FORM ELEMENTS --- */
        .form-label {
            font-size: 13px; font-weight: 600; color: #555; margin-bottom: 8px; text-transform: uppercase;
        }

        .form-control {
            height: 50px; border-radius: 10px; border: 1px solid #e0e0e0;
            background-color: #f9f9f9; font-size: 14px; padding-left: 15px;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            background-color: #fff; border-color: #2a5298; box-shadow: 0 0 0 4px rgba(42, 82, 152, 0.1);
        }

        /* Button */
        .btn-submit {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white; height: 50px; border-radius: 10px; border: none;
            font-weight: 600; letter-spacing: 1px; transition: 0.3s;
            box-shadow: 0 4px 15px rgba(30, 60, 114, 0.2);
        }
        .btn-submit:hover {
            transform: translateY(-2px); box-shadow: 0 6px 20px rgba(30, 60, 114, 0.3); color: white;
        }

        /* --- TABLE STYLING --- */
        .table-scroll-area {
            max-height: 500px; overflow-y: auto; /* Internal Scroll */
        }

        .custom-table { width: 100%; border-collapse: separate; border-spacing: 0; }
        
        .custom-table th {
            position: sticky; top: 0; z-index: 2;
            background-color: #f8f9fa; color: #1e3c72;
            font-weight: 700; font-size: 12px; text-transform: uppercase;
            padding: 15px 20px; border-bottom: 2px solid #eef2f7;
        }

        .custom-table td {
            padding: 15px 20px; vertical-align: middle;
            border-bottom: 1px solid #f1f1f1; color: #444; font-size: 14px; background: #fff;
        }

        .custom-table tr:hover td { background-color: #fcfdff; }

        /* Delete Icon */
        .action-icon {
            width: 35px; height: 35px; border-radius: 8px;
            display: inline-flex; align-items: center; justify-content: center;
            transition: 0.2s; text-decoration: none; border: none; cursor: pointer;
        }
        .icon-del { background: #ffebee; color: #e53935; }
        .icon-del:hover { background: #e53935; color: white; }

        .count-badge {
            background: rgba(255,255,255,0.2); padding: 2px 10px; border-radius: 20px; font-size: 12px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    <div class="container-fluid">
        <div class="row g-4">
            
            <div class="col-lg-4">
                <div class="admin-card">
                    <div class="card-header-blue">
                        <h5><i class="fas fa-plus-circle me-2"></i> Add New City</h5>
                    </div>
                    <div class="p-4">
                        <asp:Label ID="lblMsg" runat="server" Text=""></asp:Label>
                        
                        <div class="mb-4">
                            <label class="form-label">City Name</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0 border-light"><i class="fas fa-map-marker-alt text-muted"></i></span>
                                <asp:TextBox ID="txtCityName" runat="server" CssClass="form-control border-start-0 ps-0" placeholder="e.g. Mumbai, Delhi"></asp:TextBox>
                            </div>
                        </div>

                        <div class="d-grid">
                            <asp:Button ID="btnAdd" runat="server" Text="Add City" CssClass="btn-submit" OnClick="btnAdd_Click" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-8">
                <div class="admin-card">
                    <div class="card-header-blue">
                        <h5><i class="fas fa-city me-2"></i> Service Cities</h5>
                        <span class="count-badge">Active List</span>
                    </div>

                    <div class="table-scroll-area">
                        <asp:GridView ID="GridView1" runat="server" CssClass="custom-table" 
                            AutoGenerateColumns="False" DataKeyNames="CityID" 
                            OnRowDeleting="GridView1_RowDeleting" 
                            GridLines="None"
                            EmptyDataText="<div class='text-center p-5 text-muted'><i class='fas fa-map-marked-alt fa-3x mb-3 opacity-25'></i><br/>No cities added yet.</div>">
                            
                            <Columns>
                                <%-- ID Column --%>
                                <asp:BoundField DataField="CityID" HeaderText="#" ItemStyle-Width="60px" ItemStyle-Font-Bold="true" ItemStyle-CssClass="text-secondary" />
                                
                                <%-- City Name --%>
                                <asp:TemplateField HeaderText="City Name">
                                    <ItemTemplate>
                                        <span class="fw-bold text-dark" style="font-size: 15px;"><%# Eval("CityName") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                
                                <%-- Delete Action --%>
                                <asp:TemplateField HeaderText="Action" ItemStyle-Width="80px" ItemStyle-CssClass="text-end">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" CssClass="action-icon icon-del" 
                                            OnClientClick="return confirm('Are you sure you want to delete this city?');" ToolTip="Delete City">
                                            <i class="fas fa-trash-alt"></i>
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

</asp:Content>