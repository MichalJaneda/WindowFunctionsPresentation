<template>
    <div class="container">
        <h3>{{ requestTime }}s</h3>
        <table class="table table-bordered table-responsive">
            <tbody>
            <tr v-for="nthMonth in months"
                :key="nthMonth">
                <td>
                    {{ monthName(nthMonth) }}
                </td>
                <td v-for="nthYear in years"
                    :key="`${nthMonth}_${nthYear}`"
                    v-b-tooltip.hover
                    :style="heatColor(monthValue(nthYear, nthMonth))"
                    :title="monthValue(nthYear, nthMonth)">
                </td>
            </tr>
            </tbody>
            <tfoot>
                <tr>
                    <td></td>
                    <td v-for="nthYear in years"
                        :key="nthYear">
                        {{ nthYear + minYear - 1 }}
                    </td>
                </tr>
            </tfoot>
        </table>
    </div>
</template>

<script>
import { get } from 'axios'

export default {
    name: 'payments_in_month',
    data() {
        return {
            payments: [],
            order: null,
            requestTime: 0,
            average_payment_per_month: [],
            maxYear: 0,
            minYear: 0,
            minPayment: 0,
            maxPayment: 0,
            years: 0,
            months: 12
        }
    },
    mounted () {
        this.fetch(null)
    },
    watch: {
      payments: function(payments) {
          this.minYear = this.payments.data.reduce((min, p) => p.year < min ? p.year : min, Infinity);
          this.maxYear = this.payments.data.reduce((max, p) => p.year > max ? p.year : max, 0);

          this.minPayment = this.payments.data.reduce((min, p) => p.payment_in_month < min ? p.payment_in_month : min, Infinity);
          this.maxPayment = this.payments.data.reduce((max, p) => p.payment_in_month > max ? p.payment_in_month : max, 0);

          this.years = this.maxYear - this.minYear + 1

          let heatmapMatrix = Array.from(Array(this.years), () => Array(12).fill(0))

          for(const payment of payments.data) {
              heatmapMatrix[payment.year - this.minYear][payment.month] = payment.payment_in_month
          }

          this.average_payment_per_month = heatmapMatrix
      }
    },
    methods: {
        fetch: function() {
            const requestStart = new Date()
            get('http://localhost:3000/api/payments/in_month', { })
                .then(response => {
                    this.payments = response.data
                    this.requestTime = (new Date().getTime() - requestStart.getTime()) / 1000
                })
        },
        monthName: (numberOfMonth) => {
            return ["January", "February", "March", "April", "May", "June",
                "July", "August", "September", "October", "November", "December"
            ][numberOfMonth - 1]
        },
        monthValue(nthYear, nthMonth) {
            return this.average_payment_per_month[nthYear - 1][nthMonth] || 0
        },
        heatColor(payment) {
            let ntile = 0
            if (payment === 0 || this.maxPayment === 0) {
                ntile = 0
            }
            else {
                ntile = (payment - this.minPayment) / (this.maxPayment - this.minPayment)
            }
            ntile = 1 - ntile

            const red = this.lerp(5, Math.round(ntile * 255));
            const green = this.lerp(10, Math.round(ntile * 255));
            const blue = this.lerp(20, Math.round(ntile * 255));

            const colour = ntile > 0 ? `rgb(${red}, ${green}, ${blue})` : `#FFFFFF`;

            return `background-color: ${colour}`
        },
        lerp(min, value) {
            return value < min ? min : value
        }
    }
}
</script>

<style scoped>
    table tbody tr td {
        padding: 0;
        width: 10px;
        height: 10px;
    }
    table tbody tr td:hover {
        background-color: gray;
    }
</style>