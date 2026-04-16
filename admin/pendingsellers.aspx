<%@ Page Title="Seller Requests" Language="C#" MasterPageFile="~/admin/AdminMaster.master" AutoEventWireup="true" CodeFile="pendingsellers.aspx.cs" Inherits="admin_pendingsellers" %>

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
        .table-scroll-area {
            max-height: 600px;
            overflow-y: auto;
        }

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
            vertical-align: middle;
            border-bottom: 1px solid #f1f1f1;
            font-size: 14px;
            color: #444;
            background: #fff;
        }

        .custom-table tr:hover td { background-color: #fcfdff; }

        /* --- CONTACT INFO STYLE --- */
        .contact-info div { margin-bottom: 3px; font-size: 13px; }
        .contact-info i { width: 18px; text-align: center; color: #1e3c72; opacity: 0.7; }

        /* --- BADGES --- */
        .badge-city {
            background: #f3f4f6; color: #374151; border: 1px solid #e5e7eb;
            padding: 4px 10px; border-radius: 6px; font-weight: 600; font-size: 12px;
        }

        /* --- ACTION BUTTONS --- */
        .btn-action-group { display: flex; gap: 8px; justify-content: flex-end; }

        .btn-custom {
            border: none; padding: 6px 12px; border-radius: 6px;
            font-size: 12px; font-weight: 600; display: inline-flex; align-items: center; gap: 5px;
            transition: 0.2s; text-decoration: none; cursor: pointer;
        }

        .btn-approve { background: #d1fae5; color: #065f46; }
        .btn-approve:hover { background: #059669; color: white; }

        .btn-reject { background: #fee2e2; color: #991b1b; }
        .btn-reject:hover { background: #dc2626; color: white; }

        .badge-active { background: #dcfce7; color: #166534; padding: 5px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; }

        /* Count Badge */
        .count-badge { background: rgba(255,255,255,0.2); padding: 3px 10px; border-radius: 20px; font-size: 12px; }

    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <div class="container-fluid">
        <div class="row">
            <div class="col-12">
                
                <div class="admin-card">
                    
                    <div class="card-header-blue">
                        <div class="d-flex align-items-center">
                            <h5 class="m-0"><i class="fas fa-user-plus me-2"></i> New Seller Requests</h5>
                        </div>
                        <span class="count-badge">Verify Identity</span>
                    </div>

                    <div class="card-body p-0">

                        <div class="p-3 border-bottom d-flex flex-wrap gap-2 align-items-center justify-content-between">
    <div class="d-flex gap-2 align-items-center">
        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control"
            Width="280px" placeholder="Search seller by name..." AutoPostBack="true"
            OnTextChanged="txtSearch_TextChanged"></asp:TextBox>

        <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btn-primary"
            OnClick="btnSearch_Click">
            <i class="fas fa-search me-1"></i> Search
        </asp:LinkButton>

        <asp:LinkButton ID="btnClear" runat="server" CssClass="btn btn-outline-secondary"
            OnClick="btnClear_Click">
            <i class="fas fa-times me-1"></i> Clear
        </asp:LinkButton>
    </div>

    <small class="text-muted">Type name and press Enter</small>
</div>


                        <asp:Label ID="lblMsg" runat="server"></asp:Label>

                        <div class="table-scroll-area">
                            <asp:GridView ID="GridView1" runat="server" CssClass="custom-table" 
                                AutoGenerateColumns="False" DataKeyNames="SellerID" 
                                OnRowCommand="GridView1_RowCommand" GridLines="None"
                                EmptyDataText="<div class='text-center p-5 text-muted'><i class='fas fa-user-check fa-3x mb-3 text-success opacity-50'></i><br/>No new seller requests pending.</div>">
                                
                                <Columns>
                                    <%-- ID --%>
                                    <asp:BoundField DataField="SellerID" HeaderText="ID" ItemStyle-Width="50px" ItemStyle-Font-Bold="true" ItemStyle-CssClass="text-secondary" />
                                    
                                    <%-- Owner Name --%>
                                    <asp:TemplateField HeaderText="Owner Name">
                                        <ItemTemplate>
                                            <span class="fw-bold text-dark" style="font-size: 15px;"><%# Eval("FullName") %></span>
                                            <div class="text-muted small">Applied: <%# Eval("RegistrationDate", "{0:dd MMM yyyy}") %></div>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <%-- Contact Info (Merged Email & Phone) --%>
                                    <asp:TemplateField HeaderText="Contact Details">
                                        <ItemTemplate>
                                            <div class="contact-info">
                                                <div><i class="fas fa-envelope"></i> <%# Eval("Email") %></div>
                                                <div><i class="fas fa-phone-alt"></i> <%# Eval("Phone") %></div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    
                                    <%-- City --%>
                                    <asp:TemplateField HeaderText="Location">
                                        <ItemTemplate>
                                            <span class="badge-city"><i class="fas fa-map-marker-alt text-danger me-1"></i> <%# Eval("CityName") %></span>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <%-- Actions --%>
                                    <asp:TemplateField HeaderText="Action" ItemStyle-Width="220px" ItemStyle-CssClass="text-end">
                                        <ItemTemplate>
                                            <div class="btn-action-group">
                                                
                                                <%-- Approve Button --%>
                                                <asp:LinkButton ID="btnApprove" runat="server" CommandName="Approve" CommandArgument='<%# Eval("SellerID") %>' 
                                                    CssClass="btn-custom btn-approve" Visible='<%# Convert.ToBoolean(Eval("IsApproved")) == false %>'>
                                                    <i class="fas fa-check"></i> Approve
                                                </asp:LinkButton>

                                                <%-- Already Active Badge (Just in case) --%>
                                                <asp:Label ID="lblApproved" runat="server" Text="Active" CssClass="badge-active" 
                                                    Visible='<%# Convert.ToBoolean(Eval("IsApproved")) == true %>'></asp:Label>

                                                <%-- Reject Button --%>
                                                <asp:LinkButton ID="btnReject" runat="server" CommandName="Reject" CommandArgument='<%# Eval("SellerID") %>' 
                                                    CssClass="btn-custom btn-reject" OnClientClick="return confirm('Are you sure? This will DELETE the seller request permanently.');">
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