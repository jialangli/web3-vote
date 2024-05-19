import { createRouter, createWebHistory } from "vue-router";
import MandateView from "../views/MandateView.vue"

const routes = [
  {
    path:"/",
    name:"home",
    component:MandateView,
  },
  {
    path:"/account",
    name:"account",
    component: () =>
      import("../views/AccountView.vue"),
  },
  {
    path:"/board",
    name:"board",
    component: () =>
      import("../views/BoardView.vue"),
  },
];

const router = createRouter({
  history:createWebHistory(process.env.BASE_URL),
  routes
});

export default router;
