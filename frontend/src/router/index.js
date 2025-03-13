import { createRouter, createWebHistory } from "vue-router";
import LoginPage from "@/views/LoginPage.vue";
import RegisterPage from "@/views/RegisterPage.vue";
import BlogList from "@/views/BlogList.vue";
import WritePost from "@/views/WritePost.vue";
import PostDetail from "@/views/PostDetail.vue";
import EditPost from "@/views/EditPost.vue";
import { useAuthStore } from "@/store/auth";

const routes = [
  { path: "/", redirect: "/blogs" },
  { path: "/blogs", component: BlogList },
  { path: "/login", component: LoginPage },
  { path: "/register", component: RegisterPage },
  { path: "/blogs/:id", component: PostDetail },
  { path: "/blogs/:id/edit", component: EditPost, meta: { requiresAuth: true } },
  { path: "/write", component: WritePost, meta: { requiresAuth: true } },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

// 認証が必要なページ保護
router.beforeEach((to, from, next) => {
  const authStore = useAuthStore();
  if (to.meta.requiresAuth && !authStore.isAuthenticated) {
    alert("ログインが必要です！");
    next("/login");
  } else {
    next();
  }
});

export default router;
