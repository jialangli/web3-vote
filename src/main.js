import { createApp } from 'vue'
import App from './App.vue'
import 'vant/lib/index.css';
import "./style.less";
import router from "./router"
createApp(App).use(router).mount('#app')
