<template>
    <div class="table-wrapper">
        <input v-model="search_query" placeholder="Search">
        <table>
            <thead>
            <tr>
                <th @click="toggleOrder('name')">User</th>
                <th @click="toggleOrder('streak')">Monthly streak of no bonus</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="user_streak in users_streaks.data"
                v-bind:key="user_streak.id">
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
            order: null,
            search_query: ''
        }
    },
    mounted () {
        this.fetch(null)
    },
    watch: {
        order: function (new_order) {
            this.fetch(new_order, this.search_query)
        },
        search_query: function (new_search) {
            this.fetch(this.order, new_search)
        }
    },
    methods: {
        fetch: function(order, search_query) {
            get('http://localhost:3000/api/bonus/streak', { params: { order: order, search: search_query } })
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