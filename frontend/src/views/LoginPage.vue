// ログインページ
<template>
  <div class="container mt-5">
    <h2>ログイン</h2>
    <form @submit.prevent="handleLogin">
      <div class="mb-3">
        <label class="form-label">メール</label>
        <input v-model="email" type="email" class="form-control" required />
      </div>
      <div class="mb-3">
        <label class="form-label">パスワード</label>
        <input v-model="password" type="password" class="form-control" required />
      </div>
      <button type="submit" class="btn btn-primary">ログイン</button>

      <p class="mt-3 text-center">
        アカウントがありませんか？
        <router-link to="/register" class="btn btn-outline-secondary ms-2">会員登録</router-link>
      </p>
    </form>
  </div>
</template>

<script>
import { ref } from "vue";
import { useAuthStore } from "@/store/auth";
import { useRouter } from "vue-router";

export default {
  setup() {
    const email = ref("");
    const password = ref("");
    const authStore = useAuthStore();
    const router = useRouter();

    const handleLogin = async () => {
      await authStore.login(email.value, password.value);
      if (authStore.isAuthenticated) router.push("/blogs");
    };

    return { email, password, handleLogin };
  },
};
</script>