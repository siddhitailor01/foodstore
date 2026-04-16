<%@ Page Title="All Restaurants" Language="C#" MasterPageFile="~/admin/AdminMaster.master" AutoEventWireup="true" CodeFile="allrestaurants.aspx.cs" Inherits="admin_allrestaurants" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        /* --- CARD STYLING --- */
        .admin-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
            border: none;
            overflow: hidden;
        }

        /* --- HEADER --- */
        .card-header-blue {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            padding: 15px 20px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .card-header-blue h5 { margin: 0; font-weight: 600; font-size: 16px; letter-spacing: 0.5px; }

        /* --- SEARCH BOX --- */
        .search-container .form-control {
            border-radius: 20px 0 0 20px;
            border: none;
            font-size: 13px;
            padding-left: 15px;
        }
        .search-container .btn {
            border-radius: 0 20px 20px 0;
            background: #fff;
            color: #1e3c72;
            border: none;
            font-weight: 600;
            font-size: 13px;
        }
        .search-container .btn:hover { background: #f0f0f0; }

        /* --- TABLE STYLING --- */
        .table-scroll-area {
            max-height: 550px;
            overflow-y: auto;
        }

        .custom-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-bottom: 0;
        }

        .custom-table th {
            position: sticky; top: 0; z-index: 5;
            background-color: #f8f9fa;
            color: #555;
            font-weight: 700;
            font-size: 12px;
            text-transform: uppercase;
            padding: 12px 15px;
            border-bottom: 2px solid #eef2f7;
            white-space: nowrap;
        }

        .custom-table td {
            padding: 10px 15px;
            vertical-align: middle;
            border-bottom: 1px solid #f1f1f1;
            font-size: 13px;
            background: #fff;
            color: #444;
        }

        .custom-table tr:hover td { background-color: #fcfdff; }

        /* Images */
        .rest-img-box {
            width: 40px; height: 40px;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            border: 1px solid #eee;
        }
        .rest-img-box img { width: 100%; height: 100%; object-fit: cover; }

        /* Status Badge */
        .badge-status {
            padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; display: inline-block;
        }
        .status-active { background-color: #d1fae5; color: #065f46; }
        .status-pending { background-color: #fef3c7; color: #92400e; }
        .status-rejected { background-color: #fee2e2; color: #991b1b; }

        /* --- ACTION ICONS --- */
        .btn-icon {
            width: 30px; height: 30px;
            border-radius: 6px;
            display: inline-flex; align-items: center; justify-content: center;
            transition: 0.2s; border: none; text-decoration: none;
        }
        
        /* View Button (Blue) */
        .btn-icon-view { background: #e0f2fe; color: #0284c7; margin-right: 5px; }
        .btn-icon-view:hover { background: #0284c7; color: white; }

        /* Delete Button (Red) */
        .btn-icon-del { background: #fee2e2; color: #dc2626; }
        .btn-icon-del:hover { background: #dc2626; color: white; }

        /* Pager */
        .pagination-ys { margin-top: 10px; display: flex; justify-content: center; gap: 5px; }
        .pagination-ys table > tbody > tr > td { border: none !important; padding: 5px; }
        .pagination-ys a, .pagination-ys span {
            padding: 5px 12px; border-radius: 5px; text-decoration: none; border: 1px solid #ddd; color: #333; font-size: 13px;
        }
        .pagination-ys span { background-color: #1e3c72; color: white; border-color: #1e3c72; }
        .pagination-ys a:hover { background-color: #f0f0f0; }

    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <div class="container-fluid">
        <div class="row">
            <div class="col-12">
                
                <div class="admin-card">
                    
                    <div class="card-header-blue">
                        <div class="d-flex align-items-center">
                            <h5 class="m-0"><i class="fas fa-database me-2"></i> All Restaurants Database</h5>
                        </div>
                        
                        <div class="input-group search-container" style="width: 350px;">
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search Name, City or Owner..."></asp:TextBox>
                            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn" OnClick="btnSearch_Click" />
                        </div>
                    </div>

                    <div class="card-body p-0">
                        <asp:Label ID="lblMsg" runat="server"></asp:Label>

                        <div class="table-scroll-area">
                            <asp:GridView ID="GridView1" runat="server" CssClass="custom-table" 
                                AutoGenerateColumns="False" DataKeyNames="RestaurantID" OnRowDeleting="GridView1_RowDeleting" 
                                EmptyDataText="<div class='text-center p-5 text-muted'>No restaurants found in database.</div>" 
                                AllowPaging="True" PageSize="15" OnPageIndexChanging="GridView1_PageIndexChanging"
                                GridLines="None">
                                
                                <Columns>
                                    <asp:BoundField DataField="RestaurantID" HeaderText="ID" ItemStyle-Width="50px" ItemStyle-Font-Bold="true" ItemStyle-CssClass="text-center text-muted" HeaderStyle-CssClass="text-center" />
                                    
                                    <%-- Image Column --%>
                                    <asp:TemplateField HeaderText="Logo" ItemStyle-Width="60px">
                                        <ItemTemplate>
                                            <div class="rest-img-box">
                                                <img src='<%# ResolveUrl("~/Images/cover/" + Eval("CoverImage")) %>' alt="Img" onerror="this.src='../Images/placeholder.png'" />
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:BoundField DataField="Name" HeaderText="Restaurant Name" ItemStyle-Font-Bold="true" ItemStyle-CssClass="text-dark" />
                                    <asp:BoundField DataField="CityName" HeaderText="City" />
                                    <asp:BoundField DataField="SellerName" HeaderText="Owner" ItemStyle-CssClass="text-secondary small" />

                                    <%-- Status Badge --%>
                                    <asp:TemplateField HeaderText="Status" ItemStyle-Width="100px" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                                        <ItemTemplate>
                                            <asp:Label ID="lblStatus" runat="server" Text='<%# GetStatusBadge(Eval("ApprovalStatus")) %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <%-- Actions --%>
                                    <asp:TemplateField HeaderText="Action" ItemStyle-Width="100px" ItemStyle-CssClass="text-end">
                                        <ItemTemplate>
                                            
                                            <a href="RestaurantDetails.aspx?id=<%# Eval("RestaurantID") %>" class="btn-icon btn-icon-view" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </a>

                                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" CssClass="btn-icon btn-icon-del" 
                                                OnClientClick="return confirm('WARNING: This will permanently delete this restaurant. Are you sure?');" ToolTip="Permanently Delete">
                                                <i class="fas fa-trash-alt"></i>
                                            </asp:LinkButton>

                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                
                                <PagerStyle CssClass="pagination-ys" HorizontalAlign="Center" />
                            </asp:GridView>
                        </div>

                    </div>
                </div>

            </div>
        </div>
    </div>

</asp:Content>