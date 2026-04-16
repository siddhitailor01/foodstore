<%@ Page Title="Reported Issues" Language="C#" MasterPageFile="~/admin/AdminMaster.master" AutoEventWireup="true" CodeFile="viewreports.aspx.cs" Inherits="admin_viewreports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        /* --- CARD STYLE --- */
        .admin-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 5px 25px rgba(0, 0, 0, 0.05);
            border: none;
            overflow: hidden;
            margin-bottom: 20px;
        }

        .card-header-blue {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            padding: 20px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .card-header-blue h5 { margin: 0; font-weight: 600; font-size: 16px; letter-spacing: 0.5px; }

        /* --- SCROLL AREA --- */
        .table-scroll-area {
            max-height: 600px;
            overflow-y: auto;
        }

        /* --- TABLE STYLE --- */
        .custom-table { width: 100%; border-collapse: separate; border-spacing: 0; }
        
        .custom-table th {
            position: sticky; top: 0; z-index: 5;
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
            color: #444;
            background: #fff;
        }

        .custom-table tr:hover td { background-color: #fff5f5; /* Light Red tint on hover for issues */ }

        /* --- REPORT CONTENT --- */
        .badge-reason {
            background: #fee2e2; color: #991b1b;
            padding: 4px 10px; border-radius: 6px;
            font-size: 11px; font-weight: 700; text-transform: uppercase;
            display: inline-block; margin-bottom: 8px;
        }

        .report-msg {
            background: #fff; border: 1px border-dashed #ffcdd2;
            padding: 10px; border-radius: 8px;
            font-size: 13px; color: #555;
            border-left: 3px solid #ef4444;
            line-height: 1.5;
        }

        .rest-name { font-size: 15px; font-weight: 700; color: #1e3c72; display: block; margin-bottom: 3px; }
        .owner-contact a { color: #555; text-decoration: none; font-size: 12px; }
        .owner-contact a:hover { color: #1e3c72; text-decoration: underline; }

        /* --- BUTTONS --- */
        .btn-action-group { display: flex; flex-direction: column; gap: 8px; align-items: flex-end; }

        .btn-custom {
            padding: 6px 15px; border-radius: 6px; font-size: 12px; font-weight: 600;
            text-decoration: none; display: inline-flex; align-items: center; gap: 6px;
            transition: 0.2s; border: none; cursor: pointer; width: 120px; justify-content: center;
        }

        .btn-ban { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
        .btn-ban:hover { background: #991b1b; color: white; border-color: #991b1b; }

        .btn-ignore { background: #f3f4f6; color: #4b5563; border: 1px solid #e5e7eb; }
        .btn-ignore:hover { background: #d1d5db; color: #1f2937; }

        .date-text { font-size: 11px; color: #999; font-weight: 600; }

    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <div class="container-fluid">
        <div class="row">
            <div class="col-12">
                
                <div class="admin-card">
                    
                    <div class="card-header-blue">
                        <div class="d-flex align-items-center">
                            <h5 class="m-0"><i class="fas fa-exclamation-triangle me-2"></i> Reported Issues</h5>
                        </div>
                        <span class="badge bg-danger">Requires Attention</span>
                    </div>

                    <div class="card-body p-0">
                        <asp:Label ID="lblMsg" runat="server"></asp:Label>

                        <div class="table-scroll-area">
                            <asp:GridView ID="GridView1" runat="server" CssClass="custom-table" 
                                AutoGenerateColumns="False" DataKeyNames="ReportID" 
                                OnRowCommand="GridView1_RowCommand" GridLines="None"
                                EmptyDataText="<div class='text-center p-5 text-muted'><i class='fas fa-shield-alt fa-3x mb-3 text-success opacity-50'></i><br/>No issues reported. System is clean.</div>">
                                
                                <Columns>
                                    
                                    <%-- Date --%>
                                    <asp:TemplateField HeaderText="Date" ItemStyle-Width="100px">
                                        <ItemTemplate>
                                            <span class="date-text"><i class="far fa-clock"></i> <%# Eval("ReportDate", "{0:dd MMM}") %></span>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <%-- Restaurant Info --%>
                                    <asp:TemplateField HeaderText="Target Restaurant" ItemStyle-Width="25%">
                                        <ItemTemplate>
                                            <span class="rest-name"><%# Eval("RestaurantName") %></span>
                                            <span class="owner-contact">
                                                <i class="fas fa-user-tie me-1 text-muted"></i>
                                                <a href='tel:<%# Eval("SellerPhone") %>' title="Call Owner">
                                                    <%# Eval("SellerPhone") %>
                                                </a>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <%-- Issue Details --%>
                                    <asp:TemplateField HeaderText="Complaint Details" ItemStyle-Width="45%">
                                        <ItemTemplate>
                                            <span class="badge-reason"><i class="fas fa-bolt me-1"></i> <%# Eval("ReportReason") %></span>
                                            <div class="report-msg">
                                                "<%# Eval("UserMessage") %>"
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <%-- Actions --%>
                                    <asp:TemplateField HeaderText="Moderation" ItemStyle-Width="15%" ItemStyle-CssClass="text-end">
                                        <ItemTemplate>
                                            <div class="btn-action-group">
                                                
                                                <asp:LinkButton ID="btnCloseRest" runat="server" CommandName="CloseShop" CommandArgument='<%# Eval("RestaurantID") %>' 
                                                    CssClass="btn-custom btn-ban" OnClientClick="return confirm('WARNING: This will DEACTIVATE the restaurant immediately. Proceed?');">
                                                    <i class="fas fa-store-slash"></i> Deactivate
                                                </asp:LinkButton>

                                                <asp:LinkButton ID="btnIgnore" runat="server" CommandName="IgnoreReport" CommandArgument='<%# Eval("ReportID") %>' 
                                                    CssClass="btn-custom btn-ignore">
                                                    <i class="fas fa-check"></i> Ignore
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