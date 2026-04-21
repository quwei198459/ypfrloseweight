import { defineStore } from 'pinia'

const TOKEN_KEY = 'admin_token'
const USERNAME_KEY = 'admin_username'

export const useAuthStore = defineStore('admin-auth', {
  state: () => ({
    token: localStorage.getItem(TOKEN_KEY) || '',
    username: localStorage.getItem(USERNAME_KEY) || '',
  }),
  getters: {
    isAuthed: (state) => Boolean(state.token),
  },
  actions: {
    setAuth(token: string, username: string) {
      this.token = token
      this.username = username
      localStorage.setItem(TOKEN_KEY, token)
      localStorage.setItem(USERNAME_KEY, username)
    },
    logout() {
      this.token = ''
      this.username = ''
      localStorage.removeItem(TOKEN_KEY)
      localStorage.removeItem(USERNAME_KEY)
    },
  },
})
