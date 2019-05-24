<template>
    <div class="wrapper">
        <apexchart type=heatmap height=350 :options="chartOptions" :series="average_payment_per_month" />

        {{ payments }}
    </div>
</template>

<script>
import { get } from 'axios'
import VueApexCharts from 'apexcharts'

export default {
    name: 'payments_in_month',
    components: {
        apexchart: VueApexCharts,
    },
    data() {
        return {
            payments: [],
            order: null,
            average_payment_per_month: [],
            chartOptions: {
                dataLabels: {
                    enabled: false
                },
                colors: ["#008FFB"]
            }
        }
    },
    mounted () {
        this.fetch(null)
    },
    watch: {
        payments: function () {
            this.payments
        }
    },
    methods: {
        fetch: function() {
            get('http://localhost:3000/api/payments/in_month', { })
                .then(response => ( this.payments = response.data ))
        }
    }
}
</script>

<style>
</style>