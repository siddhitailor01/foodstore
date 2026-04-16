<%@ Page Title="Customer Queries" Language="C#" MasterPageFile="~/admin/AdminMaster.master" AutoEventWireup="true" CodeFile="viewqueries.aspx.cs" Inherits="admin_viewqueries" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        /* --- CARD & HEADER --- */
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

        /* --- SCROLL AREA (NEW) --- */
        .table-scroll-area {
            max-height: 600px; /* Is height ke baad scroll aayega */
            overflow-y: auto;
            scrollbar-width: thin; /* Firefox */
        }
        
        /* Custom Scrollbar for Chrome/Safari */
        .table-scroll-area::-webkit-scrollbar { width: 6px; }
        .table-scroll-area::-webkit-scrollbar-track { background: #f1f1f1; }
        .table-scroll-area::-webkit-scrollbar-thumb { background: #c1c1c1; border-radius: 3px; }
        .table-scroll-area::-webkit-scrollbar-thumb:hover { background: #a8a8a8; }

        /* --- INBOX TABLE STYLE --- */
        .inbox-table { width: 100%; border-collapse: collapse; }
        
        .inbox-table tr { border-bottom: 1px solid #f0f0f0; transition: 0.2s; }
        .inbox-table tr:hover { background-color: #f8f9fa; }
        .inbox-table tr:last-child { border-bottom: none; }

        .inbox-table td { padding: 20px; vertical-align: top; }

        /* --- COLUMN 1: SENDER INFO --- */
        .sender-profile { display: flex; gap: 15px; }
        
        .sender-avatar {
            width: 45px; height: 45px;
            background: #e0f2fe; color: #0284c7;
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 18px;
            flex-shrink: 0;
        }

        .sender-meta h6 { margin: 0 0 4px 0; font-size: 15px; font-weight: 700; color: #333; }
        .sender-meta span { display: block; font-size: 12px; color: #777; margin-bottom: 2px; }
        .sender-meta i { width: 16px; text-align: center; color: #1e3c72; opacity: 0.7; }

        /* --- COLUMN 2: MESSAGE CONTENT --- */
        .message-content h5 { font-size: 15px; font-weight: 700; color: #1e3c72; margin-bottom: 8px; }
        .message-content p { font-size: 14px; color: #555; line-height: 1.6; margin: 0; }
        
        /* --- COLUMN 3: ACTIONS --- */
        .action-group { display: flex; flex-direction: column; gap: 8px; align-items: flex-end; }
        
        .btn-mini {
            padding: 6px 12px; font-size: 12px; font-weight: 600; border-radius: 6px;
            text-decoration: none; display: inline-flex; align-items: center; gap: 8px;
            width: 100px; justify-content: center; transition: 0.2s; border: none;
        }

        .btn-call { background: #dcfce7; color: #166534; }
        .btn-call:hover { background: #166534; color: white; }

        .btn-email { background: #dbeafe; color: #1e40af; }
        .btn-email:hover { background: #1e40af; color: white; }

        .btn-del { background: #fee2e2; color: #991b1b; }
        .btn-del:hover { background: #991b1b; color: white; }

    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <div class="container-fluid">
        <div class="row">
            <div class="col-12">
                
                <div class="admin-card">
                    
                    <div class="card-header-blue">
                        <div class="d-flex align-items-center">
                            <h5 class="m-0"><i class="fas fa-inbox me-2"></i> Support Inbox</h5>
                        </div>
                    </div>

                    <div class="card-body p-0">
                        <asp:Label ID="lblMsg" runat="server"></asp:Label>

                        <div class="table-scroll-area">
                            <asp:GridView ID="gvQueries" runat="server" CssClass="inbox-table" 
                                AutoGenerateColumns="False" DataKeyNames="QueryID" 
                                OnRowDeleting="gvQueries_RowDeleting" 
                                GridLines="None"
                                ShowHeader="false"
                                EmptyDataText="<div class='text-center p-5 text-muted'><i class='far fa-envelope-open fa-3x mb-3 opacity-25'></i><br/>Inbox is empty. No queries found.</div>">
                                
                                <Columns>
                                    
                                    <%-- COL 1: Sender Info (Who & When) --%>
                                    <asp:TemplateField ItemStyle-Width="25%">
                                        <ItemTemplate>
                                            <div class="sender-profile">
                                                <div class="sender-avatar">
                                                    <%# Eval("Name").ToString().Substring(0, 1).ToUpper() %>
                                                </div>
                                                <div class="sender-meta">
                                                    <h6><%# Eval("Name") %></h6>
                                                    <span><i class="far fa-clock"></i> <%# Eval("QueryDate", "{0:dd MMM, hh:mm tt}") %></span>
                                                    <span><i class="fas fa-phone-alt"></i> <%# Eval("Phone") %></span>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <%-- COL 2: Message Content (What) --%>
                                    <asp:TemplateField ItemStyle-Width="60%">
                                        <ItemTemplate>
                                            <div class="message-content">
                                                <h5><%# Eval("Subject") %></h5>
                                                <p><%# Eval("Message") %></p>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <%-- COL 3: Actions (Do) --%>
                                    <asp:TemplateField ItemStyle-Width="15%" ItemStyle-VerticalAlign="Middle">
                                        <ItemTemplate>
                                            <div class="action-group">
                                                
                                                <a href='tel:<%# Eval("Phone") %>' class="btn-mini btn-call" title="Call Customer">
                                                    <i class="fas fa-phone"></i> Call
                                                </a>

                                                <a href='mailto:<%# Eval("Email") %>' class="btn-mini btn-email" title="Reply via Email">
                                                    <i class="fas fa-envelope"></i> Reply
                                                </a>

                                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" 
                                                    CssClass="btn-mini btn-del" 
                                                    OnClientClick="return confirm('Delete this message permanently?');" ToolTip="Delete Query">
                                                    <i class="fas fa-trash-alt"></i> Delete
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