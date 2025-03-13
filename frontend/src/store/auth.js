// Pinia状態管理
import { defineStore } from "pinia";
import API from "@/utils/api";

export const useAuthStore = defineStore("auth", {
  state: () => ({
    token: localStorage.getItem("token") || "",
    userId: localStorage.getItem("userId") || "", // Local Storageで自動ロード
  }),
  actions: {
    async login(email, password) {
      try {
        const response = await API.post("/login", { email, password });
        
        this.token = response.data.token;
        this.userId = response.data.userId || response.data.user?.id; // バックエンド応答キー確認

        if (!this.userId) {
          console.error("ログイン応答でuserIdが見つからない！", response.data);
          return;
        }

        localStorage.setItem("token", this.token);
        localStorage.setItem("userId", this.userId);
      } catch (error) {
        console.error("ログイン失敗:", error);
      }
    },
    async register(email, password) {
      try {
        await API.post("/users", { 
          user: {  //  Railsが期待するキーに合わせる
            email, 
            password 
          }
        });
    
        console.log("会員登録成功！");
      } catch (error) {
        console.error("会員登録失敗:", error);
      }
    },
    logout() {
      this.token = "";
      this.userId = "";
      localStorage.removeItem("token");
      localStorage.removeItem("userId");
    },
    loadUserFromStorage() {
      this.token = localStorage.getItem("token") || "";
      this.userId = localStorage.getItem("userId") || "";
    },
  },
  getters: {
    isAuthenticated: (state) => !!state.token,
  },
});
