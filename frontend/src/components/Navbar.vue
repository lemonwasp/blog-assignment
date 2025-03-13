<template>
  <nav class="navbar navbar-light bg-white shadow-sm">
    <div class="container d-flex justify-content-between">
      <router-link to="/blogs" class="navbar-brand fw-bold fs-4 text-primary">📘 blog</router-link>

      <div>
        <router-link to="/write" v-if="authStore.isAuthenticated" class="btn btn-outline-primary me-2">✍ 新規投稿</router-link>
        <router-link to="/login" v-if="!authStore.isAuthenticated" class="btn btn-outline-success">🔑 ログイン</router-link>
        <button v-if="authStore.isAuthenticated" @click="logout" class="btn btn-outline-danger">🚪 ログアウト</button>
      </div>
    </div>
  </nav>
</template>


<script>
import { useAuthStore } from "@/store/auth";
import { useRouter } from "vue-router";

export default {
  setup() {
    const authStore = useAuthStore();
    const router = useRouter();

    const logout = () => {
      authStore.logout();
      router.push("/login");
    };

    return { authStore, logout };
  },
};
</script>
