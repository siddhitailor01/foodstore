<%@ Page Title="Call History" Language="C#" MasterPageFile="~/seller/SellerMaster.master" AutoEventWireup="true" CodeFile="leadhistory.aspx.cs" Inherits="seller_leadhistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        .filter-card {
            background: #fff;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.03);
            margin-bottom: 25px;
        }
        .table-custom th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #555;
            border-bottom: 2px solid #eee;
        }
        .table-custom td {
            vertical-align: middle;
            color: #333;
            font-size: 14px;
            padding: 12px;
        }
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #999;
        }
        .pagination-ys {
            /* Bootstrap style pagination for GridView */
            display: inline-block;
            padding-left: 0;
            margin: 20px 0;
            border-radius: 4px;
        }
        .pagination-ys table > tbody > tr > td {
            display: inline;
        }
        .pagination-ys table > tbody > tr > td > a,
        .pagination-ys table > tbody > tr > td > span {
            position: relative;
            float: left;
            padding: 8px 12px;
            line-height: 1.42857143;
            text-decoration: none;
            color: #0284c7;
            background-color: #ffffff;
            border: 1px solid #dddddd;
            margin-left: -1px;
        }
        .pagination-ys table > tbody > tr > td > span {
            position: relative;
            float: left;
            padding: 8px 12px;
            line-height: 1.42857143;
            text-decoration: none;
            margin-left: -1px;
            z-index: 2;
            color: #fff;
            background-color: #0284c7;
            border-color: #0284c7;
            cursor: default;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold text-dark mb-1">Interaction History</h4>
            <small class="text-muted">View details of all calls received on your restaurants.</small>
        </div>
    </div>

    <div class="filter-card">
        <div class="row g-3 align-items-end">
            <div class="col-md-3">
                <label class="form-label small fw-bold text-muted">Select Restaurant</label>
                <asp:DropDownList ID="ddlRestaurant" runat="server" CssClass="form-select"></asp:DropDownList>
            </div>
            
            <div class="col-md-3">
                <label class="form-label small fw-bold text-muted">From Date</label>
                <asp:TextBox ID="txtStartDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
            </div>

            <div class="col-md-3">
                <label class="form-label small fw-bold text-muted">To Date</label>
                <asp:TextBox ID="txtEndDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
            </div>

            <div class="col-md-3">
                <div class="d-flex gap-2">
                    <asp:Button ID="btnSearch" runat="server" Text="Filter Data" CssClass="btn btn-primary w-100" OnClick="btnSearch_Click" />
                    <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-light border" OnClick="btnReset_Click" />
                </div>
            </div>
        </div>
    </div>

    <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
        <div class="table-responsive">
            <asp:GridView ID="gvHistory" runat="server" AutoGenerateColumns="False" 
                CssClass="table table-custom table-hover mb-0" GridLines="None"
                AllowPaging="True" PageSize="15" OnPageIndexChanging="gvHistory_PageIndexChanging">
                
                <Columns>
                    <asp:TemplateField HeaderText="Date & Time">
                        <ItemTemplate>
                            <div class="d-flex flex-column">
                                <span class="fw-bold"><%# Eval("ActionDate", "{0:dd MMM yyyy}") %></span>
                                <small class="text-muted"><%# Eval("ActionDate", "{0:hh:mm tt}") %></small>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Restaurant">
                        <ItemTemplate>
                            <div class="d-flex align-items-center">
                                <img src='<%# ResolveUrl("~/Images/cover/" + Eval("CoverImage")) %>' class="rounded-circle border me-2" width="35" height="35" style="object-fit:cover;">
                                <span><%# Eval("Name") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Action Type">
                        <ItemTemplate>
                            <span class="badge bg-primary bg-opacity-10 text-primary border border-primary px-3 rounded-pill">
                                <i class="fas fa-phone-alt me-1"></i> Call Received
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class="text-success small fw-bold"><i class="fas fa-check-circle"></i> Logged</span>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>

                <EmptyDataTemplate>
                    <div class="empty-state">
                        <i class="fas fa-history fa-3x mb-3 text-light-secondary"></i>
                        <h5>No History Found</h5>
                        <p>Try changing the dates or select a different restaurant.</p>
                    </div>
                </EmptyDataTemplate>

                <PagerStyle CssClass="pagination-ys" HorizontalAlign="Right" />
            </asp:GridView>
        </div>
    </div>

</asp:Content>
