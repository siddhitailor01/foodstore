<%@ Page Title="Pending Approvals" Language="C#" MasterPageFile="~/admin/AdminMaster.master" AutoEventWireup="true" CodeFile="pendingrestaurants.aspx.cs" Inherits="admin_pendingrestaurants" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        /* --- CARD STYLING --- */
        .admin-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
            border: none;
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
        .card-header-blue h5 { margin: 0; font-weight: 600; font-size: 16px; letter-spacing: 0.5px; }

        /* --- TABLE STYLING --- */
        .custom-table { width: 100%; border-collapse: separate; border-spacing: 0; }
        
        .custom-table th {
            background-color: #f8f9fa;
            color: #555;
            font-weight: 700;
            font-size: 12px;
            text-transform: uppercase;
            padding: 15px 20px;
            border-bottom: 2px solid #eef2f7;
        }

        .custom-table td {
            padding: 15px 20px;
            vertical-align: middle;
            border-bottom: 1px solid #f1f1f1;
            font-size: 14px;
            color: #444;
            background: #fff;
        }

        .custom-table tr:hover td { background-color: #fcfdff; }

        /* --- LINKS --- */
        .rest-link {
            color: #1e3c72; text-decoration: none; font-weight: 700; font-size: 15px;
            display: inline-block; transition: 0.2s;
        }
        .rest-link:hover { color: #0d6efd; text-decoration: underline; transform: translateX(3px); }

        /* --- BADGES & TAGS --- */
        .category-badge {
            background: #e0f2fe; color: #0284c7;
            padding: 4px 10px; border-radius: 6px;
            font-size: 11px; font-weight: 600;
            text-transform: uppercase;
        }

        /* --- ACTION BUTTONS --- */
        .btn-action-group { display: flex; gap: 10px; justify-content: flex-end; }

        .btn-custom {
            border: none;
            padding: 6px 15px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: 0.2s;
            text-decoration: none;
            cursor: pointer;
        }

        .btn-approve { background: #d1fae5; color: #065f46; }
        .btn-approve:hover { background: #059669; color: white; transform: translateY(-1px); }

        .btn-reject { background: #fee2e2; color: #991b1b; }
        .btn-reject:hover { background: #dc2626; color: white; transform: translateY(-1px); }

        /* Pending Count Badge in Header */
        .pending-badge {
            background: rgba(255,255,255,0.2);
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 12px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <div class="container-fluid">
        <div class="row">
            <div class="col-12">
                
                <div class="admin-card">
                    
                    <div class="card-header-blue">
                        <div class="d-flex align-items-center">
                            <h5 class="m-0"><i class="fas fa-user-clock me-2"></i> Pending Approvals</h5>
                        </div>
                        <span class="pending-badge">Action Required</span>
                    </div>

                    <div class="card-body p-0">
                        
                        <div class="table-responsive">
                            <asp:GridView ID="GridView1" runat="server" CssClass="custom-table" 
                                AutoGenerateColumns="False" DataKeyNames="RestaurantID" 
                                OnRowCommand="GridView1_RowCommand" GridLines="None"
                                EmptyDataText="<div class='text-center p-5 text-muted'><i class='fas fa-check-circle fa-3x mb-3 text-success opacity-50'></i><br/>All caught up! No pending requests.</div>">
                                
                                <Columns>
                                    <%-- ID --%>
                                    <asp:BoundField DataField="RestaurantID" HeaderText="ID" ItemStyle-Width="50px" ItemStyle-Font-Bold="true" ItemStyle-CssClass="text-secondary" />
                                    
                                    <%-- Name (LINKED TO DETAILS) --%>
                                    <asp:TemplateField HeaderText="Restaurant Name">
                                        <ItemTemplate>
                                            <a href="RestaurantDetails.aspx?id=<%# Eval("RestaurantID") %>" class="rest-link" title="View Full Details">
                                                <%# Eval("Name") %> <i class="fas fa-external-link-alt small ms-1 text-muted" style="font-size: 10px;"></i>
                                            </a>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <%-- City --%>
                                    <asp:BoundField DataField="CityName" HeaderText="Location" />

                                    <%-- Category --%>
                                    <asp:TemplateField HeaderText="Category">
                                        <ItemTemplate>
                                            <span class="category-badge"><%# Eval("CategoryName") %></span>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <%-- Phone --%>
                                    <asp:TemplateField HeaderText="Phone">
                                        <ItemTemplate>
                                            <span class="text-muted"><i class="fas fa-phone-alt me-1" style="font-size:11px;"></i> <%# Eval("Phone") %></span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    
                                    <%-- Actions --%>
                                    <asp:TemplateField HeaderText="Review & Action" ItemStyle-Width="200px" ItemStyle-CssClass="text-end">
                                        <ItemTemplate>
                                            <div class="btn-action-group">
                                                <asp:LinkButton ID="btnApprove" runat="server" CommandName="Approve" CommandArgument='<%# Eval("RestaurantID") %>' 
                                                    CssClass="btn-custom btn-approve" ToolTip="Approve and make live">
                                                    <i class="fas fa-check"></i> Approve
                                                </asp:LinkButton>

                                                <asp:LinkButton ID="btnReject" runat="server" CommandName="Reject" CommandArgument='<%# Eval("RestaurantID") %>' 
                                                    CssClass="btn-custom btn-reject" OnClientClick="return confirm('Are you sure you want to REJECT this restaurant?');" ToolTip="Reject request">
                                                    <i class="fas fa-times"></i> Reject
                                                </asp:LinkButton>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>

                    </div>
                </div>

            </div>
        </div>
    </div>

</asp:Content>