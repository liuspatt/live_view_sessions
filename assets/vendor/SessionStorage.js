const Storage = {
    mounted() {
        this.handleEvent("store", (obj) => this.store(obj))
        this.handleEvent("clear", (obj) => this.clear(obj))
        this.handleEvent("restore", (obj) => this.restore(obj))
    },  

    store(obj) {
        sessionStorage.setItem(obj.key, obj.data)
    },

    restore(obj) {
      var data = sessionStorage.getItem(obj.key)
      if (data !== null && obj.key !== null) {
        this.pushEvent(obj.event, data)
      }
    },
  
    clear(obj) {
      sessionStorage.removeItem(obj.key)
    }
}

export default Storage
