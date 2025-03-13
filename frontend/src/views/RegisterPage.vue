// 会員登録ページ
<template>
  <div class="container mt-5">
    <h2>会員登録</h2>
    <form @submit.prevent="handleRegister">
      <div class="mb-3">
        <label class="form-label">メール</label>
        <input v-model="email" type="email" class="form-control" required />
      </div>
      <div class="mb-3">
        <label class="form-label">パスワード</label>
        <input v-model="password" type="password" class="form-control" required />
      </div>
      <button type="submit" class="btn btn-success">会員登録</button>
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

    const handleRegister = async () => {
      await authStore.register(email.value, password.value);
      router.push("/login");
    };

    return { email, password, handleRegister };
  },
};
</script>
