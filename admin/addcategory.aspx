<%@ Page Title="Manage Categories" Language="C#" MasterPageFile="~/admin/AdminMaster.master" AutoEventWireup="true" CodeFile="addcategory.aspx.cs" Inherits="admin_addcategory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        /* --- GENERAL CARD --- */
        .admin-card {
            background: #fff;
            border-radius: 15px;
            border: none;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            margin-bottom: 20px;
        }

        /* --- HEADER --- */
        .card-header-blue {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            padding: 20px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .card-header-blue h5 { margin: 0; font-weight: 600; font-size: 16px; }

        /* --- FORM --- */
        .form-label { font-size: 13px; font-weight: 600; color: #555; text-transform: uppercase; margin-bottom: 8px; }
        .form-control {
            height: 50px; border-radius: 10px; border: 1px solid #e0e0e0;
            background-color: #f9f9f9; font-size: 14px; padding-left: 15px;
        }
        .form-control:focus { background-color: #fff; border-color: #2a5298; box-shadow: none; }
        input[type="file"].form-control { padding-top: 12px; }

        /* Buttons */
        .btn-submit {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white; height: 50px; border-radius: 10px; border: none; font-weight: 600; transition: 0.3s;
        }
        .btn-submit:hover { transform: translateY(-2px); color: white; box-shadow: 0 5px 15px rgba(30,60,114,0.3); }
        .btn-cancel { background: #f1f3f5; color: #333; border: none; height: 50px; border-radius: 10px; font-weight: 600; }

        /* --- TABLE AREA (SCROLL FIX) --- */
        .table-scroll-area {
            max-height: 500px; /* Fixed height so page doesn't grow too long */
            overflow-y: auto;  /* Enable internal scrolling */
        }

        .custom-table { width: 100%; border-collapse: separate; border-spacing: 0; }
        .custom-table th {
            position: sticky; top: 0; z-index: 2; /* Sticky Header */
            background-color: #f8f9fa; color: #1e3c72; font-weight: 700;
            font-size: 12px; text-transform: uppercase; padding: 15px 20px;
            border-bottom: 2px solid #eef2f7;
        }
        .custom-table td { padding: 15px 20px; vertical-align: middle; border-bottom: 1px solid #f1f1f1; font-size: 14px; background: #fff; }
        .custom-table tr:hover td { background-color: #fcfdff; }

        /* Images & Actions */
        .cat-img-box { width: 50px; height: 50px; border-radius: 10px; overflow: hidden; box-shadow: 0 3px 6px rgba(0,0,0,0.1); border: 1px solid #eee; }
        .cat-img-box img { width: 100%; height: 100%; object-fit: cover; }

        .action-icon {
            width: 35px; height: 35px; border-radius: 8px; display: inline-flex; align-items: center; justify-content: center;
            transition: 0.2s; text-decoration: none; border: none; cursor: pointer;
        }
        .icon-edit { background: #e3f2fd; color: #1e88e5; }
        .icon-edit:hover { background: #1e88e5; color: white; }
        .icon-del { background: #ffebee; color: #e53935; }
        .icon-del:hover { background: #e53935; color: white; }

        .count-badge { background: rgba(255,255,255,0.2); padding: 2px 10px; border-radius: 20px; font-size: 12px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    <div class="container-fluid">
        <div class="row g-4">
            
            <div class="col-lg-4">
                <div class="admin-card">
                    <div class="card-header-blue" id="headerDiv" runat="server">
                        <h5><i class="fas fa-plus-circle me-2"></i> <asp:Label ID="lblHeader" runat="server" Text="Add Category"></asp:Label></h5>
                    </div>
                    <div class="p-4">
                        <asp:Label ID="lblMsg" runat="server" Text=""></asp:Label>
                        <asp:HiddenField ID="hfCatID" runat="server" Value="0" />
                        
                        <div class="mb-3">
                            <label class="form-label">Category Name</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0 border-light"><i class="fas fa-tag text-muted"></i></span>
                                <asp:TextBox ID="txtCategoryName" runat="server" CssClass="form-control border-start-0 ps-0" placeholder="e.g. Pizza"></asp:TextBox>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Category Image</label>
                            <asp:FileUpload ID="fuCatImage" runat="server" CssClass="form-control" />
                            <small class="text-muted" style="font-size: 11px; display: block; margin-top: 5px;">
                                <i class="fas fa-info-circle"></i> Upload image. Leave empty if editing.
                            </small>
                        </div>

                        <div class="d-flex gap-2">
                            <asp:Button ID="btnAdd" runat="server" Text="Save Category" CssClass="btn-submit w-100" OnClick="btnAdd_Click" />
                            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn-cancel w-50" OnClick="btnCancel_Click" Visible="false" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-8">
                <div class="admin-card">
                    
                    <div class="card-header-blue">
                        <h5><i class="fas fa-list me-2"></i> Category List</h5>
                        <span class="count-badge">Total: <asp:Label ID="lblCount" runat="server" Text="0"></asp:Label></span>
                    </div>

                    <div class="table-scroll-area">
                        <asp:GridView ID="GridView1" runat="server" CssClass="custom-table" 
                            AutoGenerateColumns="False" DataKeyNames="CategoryID" 
                            OnRowDeleting="GridView1_RowDeleting" 
                            OnRowCommand="GridView1_RowCommand"
                            GridLines="None"
                            EmptyDataText="<div class='text-center p-5 text-muted'><i class='fas fa-box-open fa-3x mb-3 opacity-25'></i><br/>No categories found.</div>">
                            
                            <Columns>
                                <asp:BoundField DataField="CategoryID" HeaderText="#" ItemStyle-Width="50px" ItemStyle-Font-Bold="true" ItemStyle-CssClass="text-secondary" />
                                
                                <asp:TemplateField HeaderText="Icon" ItemStyle-Width="80px">
                                    <ItemTemplate>
                                        <div class="cat-img-box">
                                            <img src='<%# Eval("CategoryImage").ToString() != "" ? ResolveUrl("~/images/category/" + Eval("CategoryImage")) : ResolveUrl("~/assets/images/placeholder.jpg") %>' 
                                                 alt="icon" onerror="this.src='../assets/images/placeholder.jpg'" />
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Category Name">
                                    <ItemTemplate>
                                        <span class="fw-bold text-dark" style="font-size: 15px;"><%# Eval("CategoryName") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                
                                <asp:TemplateField HeaderText="Actions" ItemStyle-Width="120px" ItemStyle-CssClass="text-end">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditCat" CommandArgument='<%# Container.DataItemIndex %>' CssClass="action-icon icon-edit" ToolTip="Edit">
                                            <i class="fas fa-pen"></i>
                                        </asp:LinkButton>

                                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" CssClass="action-icon icon-del ms-2" 
                                            OnClientClick="return confirm('Delete this category permanently?');" ToolTip="Delete">
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