<%@ Page Title="Manage Reviews" Language="C#" MasterPageFile="~/admin/AdminMaster.master" AutoEventWireup="true" CodeFile="managereviews.aspx.cs" Inherits="admin_managereviews" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        /* --- CARD STYLE --- */
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
            padding: 20px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .card-header-blue h5 { margin: 0; font-weight: 600; font-size: 16px; letter-spacing: 0.5px; }

        /* --- TABLE STYLE --- */
        .custom-table { width: 100%; border-collapse: separate; border-spacing: 0; margin-bottom: 0; }
        
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
            vertical-align: top;
            border-bottom: 1px solid #f1f1f1;
            font-size: 14px;
            background: #fff;
            color: #444;
        }

        .custom-table tr:hover td { background-color: #fcfdff; }

        /* --- REVIEW CONTENT --- */
        .review-text {
            background: #f9f9f9;
            padding: 10px 15px;
            border-radius: 8px;
            border-left: 3px solid #ffc107;
            font-style: italic;
            color: #555;
            font-size: 13px;
            margin-top: 5px;
        }

        .star-rating { color: #ffc107; font-size: 14px; letter-spacing: 2px; }
        .customer-name { font-weight: 600; color: #333; display: block; }
        .review-date { font-size: 11px; color: #999; }

        /* --- ACTION BUTTONS --- */
        .btn-action {
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            border: none;
            transition: 0.2s;
            display: inline-flex; align-items: center; gap: 5px; text-decoration: none;
        }
        
        .btn-approve { background: #d1fae5; color: #065f46; }
        .btn-approve:hover { background: #065f46; color: white; }

        .btn-reject { background: #fee2e2; color: #991b1b; }
        .btn-reject:hover { background: #991b1b; color: white; }

    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <div class="container-fluid">
        <div class="row">
            <div class="col-12">
                
                <div class="admin-card">
                    
                    <div class="card-header-blue">
                        <div class="d-flex align-items-center">
                            <h5 class="m-0"><i class="fas fa-star-half-alt me-2"></i> Manage Customer Reviews</h5>
                        </div>
                        <span class="badge bg-light text-dark bg-opacity-25 border border-white text-white">Pending Approval</span>
                    </div>

                    <div class="card-body p-0">
                        <asp:Label ID="lblMsg" runat="server"></asp:Label>

                        <div class="table-responsive">
                            <asp:GridView ID="gvReviews" runat="server" CssClass="custom-table" 
                                AutoGenerateColumns="False" OnRowCommand="gvReviews_RowCommand" DataKeyNames="ReviewID"
                                GridLines="None"
                                EmptyDataText="<div class='text-center p-5 text-muted'><i class='far fa-smile fa-3x mb-3 opacity-25'></i><br/>No pending reviews found.</div>">
                                
                                <Columns>
                                    <%-- Date & Restaurant --%>
                                    <asp:TemplateField HeaderText="Restaurant Info" ItemStyle-Width="250px">
                                        <ItemTemplate>
                                            <span class="fw-bold text-primary d-block mb-1"><%# Eval("RestaurantName") %></span>
                                            <span class="review-date"><i class="far fa-calendar-alt me-1"></i> <%# Eval("ReviewDate", "{0:dd MMM yyyy}") %></span>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <%-- Customer & Rating --%>
                                    <asp:TemplateField HeaderText="Customer Feedback">
                                        <ItemTemplate>
                                            <div class="d-flex align-items-center justify-content-between mb-1">
                                                <span class="customer-name"><%# Eval("UserName") %></span>
                                                <div class="star-rating">
                                                    <%# GenerateStars(Convert.ToInt32(Eval("Rating"))) %>
                                                </div>
                                            </div>
                                            <div class="review-text">
                                                "<%# Eval("ReviewText") %>"
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <%-- Actions --%>
                                    <asp:TemplateField HeaderText="Action" ItemStyle-Width="200px" ItemStyle-VerticalAlign="Middle" ItemStyle-CssClass="text-end">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="btnApprove" runat="server" CommandName="ApproveReview" 
                                                CommandArgument='<%# Eval("ReviewID") %>' CssClass="btn-action btn-approve me-2" ToolTip="Publish Review">
                                                <i class="fas fa-check"></i> Approve
                                            </asp:LinkButton>

                                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteReview" 
                                                CommandArgument='<%# Eval("ReviewID") %>' CssClass="btn-action btn-reject"
                                                OnClientClick="return confirm('Delete this review permanently?');" ToolTip="Delete Review">
                                                <i class="fas fa-trash"></i> Delete
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
    </div>

</asp:Content>