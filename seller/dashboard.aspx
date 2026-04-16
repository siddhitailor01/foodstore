<%@ Page Title="Seller Dashboard" Language="C#" MasterPageFile="~/seller/SellerMaster.master" AutoEventWireup="true" CodeFile="dashboard.aspx.cs" Inherits="seller_dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f8f9fa; }

        /* --- DASHBOARD CARDS --- */
        .card-box {
            background: #ffffff;
            border-radius: 16px;
            padding: 25px;
            border: none;
            box-shadow: 0 2px 15px rgba(0,0,0,0.03);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
            position: relative;
        }

        .card-box:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
        }

        .card-title-text {
            color: #6c757d;
            font-size: 13px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
        }

        .card-metric {
            font-size: 32px;
            font-weight: 700;
            color: #212529;
            margin-bottom: 0;
            line-height: 1.2;
        }

        .icon-shape {
            width: 55px;
            height: 55px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            margin-bottom: 15px;
        }

        .bg-light-primary { background: #e0f2fe; color: #0284c7; }
        .bg-light-success { background: #dcfce7; color: #16a34a; }
        .bg-light-warning { background: #fef9c3; color: #ca8a04; }
        .bg-light-danger  { background: #fee2e2; color: #dc2626; }

        /* --- CHART SECTION --- */
        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .chart-title {
            font-size: 16px;
            font-weight: 700;
            color: #343a40;
            margin: 0;
        }

        /* --- TABLE SECTION --- */
        .table-custom th {
            font-weight: 600;
            color: #555;
            border-bottom-width: 1px;
            font-size: 13px;
            background: #f8f9fa;
        }
        .table-custom td {
            font-size: 14px;
            vertical-align: middle;
            color: #333;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <div>
            <h4 class="mb-0 fw-bold text-dark">Dashboard</h4>
            <small class="text-muted">Overview of your restaurant performance</small>
        </div>
        <div class="d-none d-sm-block bg-white px-3 py-2 rounded-pill shadow-sm text-muted small fw-bold">
            <i class="fas fa-calendar-alt me-2 text-primary"></i> <%= DateTime.Now.ToString("dd MMM yyyy") %>
        </div>
    </div>

    <div class="row g-4 mb-4">
        
        <div class="col-xl-3 col-md-6">
            <div class="card-box">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <div class="card-title-text">Total Calls</div>
                        <asp:Label ID="lblTotalLeads" runat="server" Text="0" CssClass="card-metric"></asp:Label>
                        <div class="mt-2 small text-success fw-bold"><i class="fas fa-arrow-up"></i> Customer Calls</div>
                    </div>
                    <div class="icon-shape bg-light-primary">
                        <i class="fas fa-phone-alt"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6">
            <div class="card-box">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <div class="card-title-text">Live Outlets</div>
                        <asp:Label ID="lblLiveRest" runat="server" Text="0" CssClass="card-metric"></asp:Label>
                        <div class="mt-2 small text-muted">Active on site</div>
                    </div>
                    <div class="icon-shape bg-light-success">
                        <i class="fas fa-store"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6">
            <div class="card-box">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <div class="card-title-text">Total Dishes</div>
                        <asp:Label ID="lblMenuItems" runat="server" Text="0" CssClass="card-metric"></asp:Label>
                        <div class="mt-2 small text-muted">Across menus</div>
                    </div>
                    <div class="icon-shape bg-light-warning">
                        <i class="fas fa-hamburger"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6">
            <div class="card-box">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <div class="card-title-text">Pending Approval</div>
                        <asp:Label ID="lblPending" runat="server" Text="0" CssClass="card-metric"></asp:Label>
                        <div class="mt-2 small text-danger fw-bold">Action Required</div>
                    </div>
                    <div class="icon-shape bg-light-danger">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-12">
            <div class="card-box">
                <div class="chart-header">
                    <h5 class="chart-title">Customer Interest (Calls Received)</h5>
                    <button class="btn btn-sm btn-light"><i class="fas fa-ellipsis-h"></i></button>
                </div>
                <div style="height: 300px; width: 100%;">
                    <canvas id="barChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
    <div class="col-12">
        <div class="card-box p-0 overflow-hidden">
            
            <div class="p-4 border-bottom d-flex justify-content-between align-items-center">
                <div>
                    <h5 class="chart-title mb-1">Today's Performance</h5>
                    <small class="text-muted">Summary of customer calls for today</small>
                </div>
                <span class="badge bg-light text-dark border">
                    <i class="fas fa-calendar-day me-1 text-danger"></i> Today
                </span>
            </div>

            <div class="table-responsive">
                <table class="table table-custom mb-0 align-middle">
                    <thead class="bg-light">
                        <tr>
                            <th class="ps-4" style="width: 50%;">Restaurant</th>
                            <th class="text-center">Calls Received</th>
                            <th class="text-end pe-4">Last Activity</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptLeads" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td class="ps-4">
                                        <div class="d-flex align-items-center">
                                            <img src='<%# ResolveUrl("~/Images/cover/" + Eval("CoverImage")) %>' 
                                                 class="rounded-circle border me-3" width="45" height="45" 
                                                 style="object-fit:cover;" onerror="this.src='../Images/placeholder.png'">
                                            <div>
                                                <h6 class="mb-0 fw-bold text-dark"><%# Eval("Name") %></h6>
                                                <small class="text-success fw-bold" style="font-size: 11px;">Active Today</small>
                                            </div>
                                        </div>
                                    </td>

                                    <td class="text-center">
                                        <div class="d-inline-flex align-items-center px-3 py-1 rounded-pill bg-primary bg-opacity-10 border border-primary">
                                            <i class="fas fa-phone-alt text-primary me-2"></i>
                                            <span class="fw-bold text-dark"><%# Eval("CallCount") %></span>
                                        </div>
                                    </td>

                                    <td class="text-end pe-4">
                                        <small class="text-muted"><%# GetTimeAgo(Eval("LastActive")) %></small>
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                <tr id="Tr1" runat="server" visible='<%# rptLeads.Items.Count == 0 %>'>
                                    <td colspan="3" class="text-center py-5">
                                        <div class="d-flex flex-column align-items-center justify-content-center opacity-50">
                                            <i class="fas fa-phone-slash fa-3x mb-3 text-secondary"></i>
                                            <h6 class="text-muted">No calls received today yet.</h6>
                                            <small>Ensure your restaurant is visible to customers!</small>
                                        </div>
                                    </td>
                                </tr>
                            </FooterTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

    <asp:HiddenField ID="hfRestNames" runat="server" Value="" />
    <asp:HiddenField ID="hfRestClicks" runat="server" Value="" />

    <script>
        document.addEventListener("DOMContentLoaded", function () {

            // Common Options
            Chart.defaults.font.family = "'Poppins', sans-serif";
            Chart.defaults.color = '#6c757d';

            // --- BAR CHART (Customer Interest) ---
            var rawNames = document.getElementById('<%= hfRestNames.ClientID %>').value;
            var rawClicks = document.getElementById('<%= hfRestClicks.ClientID %>').value;

            var labels = rawNames ? rawNames.split(',') : ['No Data'];
            var dataPoints = rawClicks ? rawClicks.split(',').map(Number) : [0];

            var ctxBar = document.getElementById('barChart').getContext('2d');

            // Create Gradient for Bar Chart
            var gradient = ctxBar.createLinearGradient(0, 0, 0, 400);
            gradient.addColorStop(0, '#0284c7'); // Blue
            gradient.addColorStop(1, '#0ea5e9'); // Light Blue

            new Chart(ctxBar, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Calls Received',
                        data: dataPoints,
                        backgroundColor: gradient,
                        borderRadius: 4,
                        barThickness: 40 // Thicker bars since we have more space now
                    }]
                },
                options: {
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: { borderDash: [2, 4], color: '#f0f0f0', drawBorder: false }
                        },
                        x: {
                            grid: { display: false, drawBorder: false }
                        }
                    },
                    plugins: {
                        legend: { display: false }
                    }
                }
            });
        });
    </script>

</asp:Content>