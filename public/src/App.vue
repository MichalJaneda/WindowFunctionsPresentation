<template>
  <div id="app">
    <div id="nav">
      <router-link to="/">Index</router-link>
      <router-link to="/no_streak">No streak</router-link>
      <router-link to="/payments_in_month">Payments in month</router-link>
    </div>
    <router-view/>
  </div>
</template>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
#nav {
  display: flex;
}
#nav > a {
  flex: 1;
}
#nav > a::before {
  content: ">>";
}
</style>
