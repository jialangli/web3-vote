<script setup>
/* eslint-disable no-unused-vars */
import { ref } from 'vue';
const active = ref(0);
</script>

<template>
  <div>
    <nav class="header">去中心化投票APP</nav>
    <main>
      <router-view></router-view>
    </main>
    <van-tabbar route v-model="active" active-color="#ee742f">
      <van-tabbar-item to="/" icon="gem-o">分发票权</van-tabbar-item>
      <van-tabbar-item to="/account" icon="balance-list-o">账户信息</van-tabbar-item>
      <van-tabbar-item to="/board" icon="orders-o">投票看板</van-tabbar-item>
    </van-tabbar>
  </div>
</template>

<style lang="less" scoped>
  .header {
    height: 44px;
    background-color: #ee742f;
    color:#fff;
    text-align:center;
    line-height: 44px;
  }
</style>
<style lang="less">
  html,
  body {
    margin: 0;
    padding: 0;
    overflow: hidden;
  }
</style>