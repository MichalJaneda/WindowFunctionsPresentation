<template>
    <div class="table-wrapper">
        <table>
            <thead>
            <tr>
                <th @click="toggleOrder('name')">User</th>
                <th @click="toggleOrder('streak')">Monthly streak of no bonus</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="user_streak in users_streaks.data">
                <td>
                    {{ user_streak.name }}
                </td>
                <td>
                    {{ user_streak.streak }}
                </td>
            </tr>
            </tbody>
        </table>
    </div>
</template>

<script>
import { get } from 'axios'

export default {
    name: 'no_streak',
    data() {
        return {
            users_streaks: [],
            order: null
        }
    },
    mounted () {
        this.fetch(null)
    },
    watch: {
        order: function (new_order) {
            this.fetch(new_order)
        }
    },
    methods: {
        fetch: function(order) {
            get('http://localhost:3000/api/bonus/streak', { params: { order: order } })
                .then(response => ( this.users_streaks = response.data ))
        },
        toggleOrder: function(field) {
            const currentValue = this.order
            let newValue = null

            if (currentValue === null) {
                newValue = `${field} ASC`
            }
            else if (currentValue === `${field} ASC`) {
                newValue = `${field} DESC`
            }
            else {
                newValue = null
            }

            this.order = newValue
        }
    }
}
</script>

<style>
table {
    width: 100%;
    border: 1px solid black;
}

    thead {
        background-color: antiquewhite;
    }
</style>