<%@ Page Title="My Restaurants" Language="C#" MasterPageFile="~/seller/SellerMaster.master" AutoEventWireup="true" CodeFile="myrestaurants.aspx.cs" Inherits="seller_myrestaurants" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        /* --- CARD CONTAINER --- */
        .table-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.05); /* Soft Shadow */
            border: none;
            overflow: hidden;
        }

        /* --- IMPROVED HEADER --- */
        .card-header-custom {
            padding: 20px 25px;
            background: #ffffff;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-left: 5px solid #d32f2f; /* Red Accent Line */
        }

        .header-title h5 {
            margin: 0;
            font-weight: 700;
            color: #333;
            font-size: 18px;
        }
        .header-title small {
            color: #888;
            font-size: 12px;
        }

        .btn-add-new {
            background: linear-gradient(45deg, #d32f2f, #ff5252);
            color: white;
            padding: 10px 20px;
            border-radius: 30px; /* Pill Shape */
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            box-shadow: 0 4px 10px rgba(211, 47, 47, 0.2);
            transition: 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .btn-add-new:hover { transform: translateY(-2px); box-shadow: 0 6px 15px rgba(211, 47, 47, 0.3); color: white; }

        /* --- TABLE STYLES --- */
        .modern-table {
            width: 100%;
            margin-bottom: 0;
            color: #444;
            border-collapse: collapse;
        }

        .modern-table thead th {
            background-color: #f8f9fa;
            color: #6b7280;
            font-weight: 700;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            padding: 18px 20px;
            border-bottom: 1px solid #e5e7eb;
            text-align: left;
        }

        .modern-table tbody td {
            padding: 15px 20px;
            vertical-align: middle;
            border-bottom: 1px solid #f3f4f6;
            font-size: 14px;
        }

        .modern-table tbody tr:hover { background-color: #fafafa; }

        /* Image */
        .img-thumb {
            width: 45px;
            height: 45px;
            border-radius: 8px;
            object-fit: cover;
            border: 1px solid #eee;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        /* Status Badges */
        .badge-status {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            display: inline-block;
            text-align: center;
            min-width: 70px;
        }
        .status-active { background-color: #def7ec; color: #03543f; }
        .status-pending { background-color: #fefcbf; color: #744210; }
        .status-rejected { background-color: #fde8e8; color: #9b1c1c; }

        /* Action Buttons Container */
        .action-container {
            display: flex;
            gap: 8px; /* Space between buttons */
            align-items: center;
        }

        /* Individual Button Styling */
        .btn-action {
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            border: none;
            transition: 0.2s;
            text-decoration: none;
            font-size: 14px;
        }
        
        .btn-view { background: #e0f2fe; color: #0284c7; }
        .btn-view:hover { background: #0284c7; color: white; }

        .btn-edit { background: #f0fdf4; color: #16a34a; }
        .btn-edit:hover { background: #16a34a; color: white; }

        .btn-del { background: #fef2f2; color: #dc2626; }
        .btn-del:hover { background: #dc2626; color: white; }

    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <div class="container-fluid py-4">
        
        <div class="table-card">
            
            <div class="card-header-custom mb-3">
                <div class="header-title">
                    <h5>My Restaurants</h5>
                    <small>Overview of all your registered outlets</small>
                </div>
                <a href="AddRestaurant.aspx" class="btn-add-new">
                    <i class="fas fa-plus"></i> Add Restaurant
                </a>
            </div>

            <asp:Label ID="lblMsg" runat="server"></asp:Label>

            <div class="table-responsive mt-4">
                <asp:GridView ID="GridView1" runat="server" 
                    CssClass="table modern-table" 
                    GridLines="None"
                    AutoGenerateColumns="False" 
                    DataKeyNames="RestaurantID" 
                    OnRowDeleting="GridView1_RowDeleting" 
                    EmptyDataText="<div class='text-center p-5 text-muted'><i class='fas fa-folder-open fa-2x mb-3 opacity-50'></i><p>No restaurants found.</p></div>">
                    
                    <Columns>
                        
                        <%-- Image --%>
                        <asp:TemplateField HeaderText="IMAGE" ItemStyle-Width="80px">
                            <ItemTemplate>
                                <img src='<%# Eval("CoverImage").ToString() != "" ? ResolveUrl("~/Images/cover/" + Eval("CoverImage").ToString()) : ResolveUrl("~/Images/placeholder.png") %>' 
                                     class="img-thumb" alt="Img" onerror="this.src='../Images/placeholder.png'" />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <%-- Name --%>
                        <asp:TemplateField HeaderText="RESTAURANT">
                            <ItemTemplate>
                                <div class="d-flex flex-column">
                                    <span class="fw-bold text-dark"><%# Eval("Name") %></span>
                                    <small class="text-muted" style="font-size:11px;">
                                        <i class="fas fa-map-marker-alt text-danger me-1"></i><%# Eval("CityName") %>
                                    </small>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <%-- Phone --%>
                        <asp:TemplateField HeaderText="PHONE">
                            <ItemTemplate>
                                <span class="text-secondary fw-medium" style="font-size:13px;"><%# Eval("Phone") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <%-- Category --%>
                        <asp:BoundField DataField="CategoryName" HeaderText="TYPE" ItemStyle-CssClass="fw-bold text-secondary small text-uppercase" />

                        <%-- Status --%>
                        <asp:TemplateField HeaderText="STATUS">
                            <ItemTemplate>
                                <asp:Label ID="lblStatus" runat="server" Text='<%# GetStatusBadge(Eval("ApprovalStatus")) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <%-- Actions (Fixed Alignment) --%>
                        <asp:TemplateField HeaderText="ACTIONS" ItemStyle-Width="150px">
                            <ItemTemplate>
                                <div class="action-container">
                                    <a href='RestaurantDetails.aspx?id=<%# Eval("RestaurantID") %>' class="btn-action btn-view" title="View Details">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href='editrestaurants.aspx?id=<%# Eval("RestaurantID") %>' class="btn-action btn-edit" title="Edit Info">
                                        <i class="fas fa-pen"></i>
                                    </a>
                                    <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" CssClass="btn-action btn-del" 
                                        OnClientClick="return confirm('Are you sure you want to delete this?');" title="Delete">
                                        <i class="fas fa-trash-alt"></i>
                                    </asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>
            </div>

        </div>

    </div>

</asp:Content>