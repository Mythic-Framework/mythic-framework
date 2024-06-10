Vue.component('suggestions', {
  template: '#suggestions_template',
  props: ['message', 'suggestions'],
  data() {
    return {};
  },
  computed: {
    currentSuggestions() {
      if (this.message === '') {
        return [];
      }
      const currentSuggestions = this.suggestions.filter((s) => {
        if (!s.name.toUpperCase().startsWith(this.message.toUpperCase())) {
          const suggestionSplitted = s.name.split(' ');
          const messageSplitted = this.message.split(' ');
          for (let i = 0; i < messageSplitted.length; i += 1) {
            if (i >= suggestionSplitted.length) {
              return i < suggestionSplitted.length + s.params.length;
            }
            if (suggestionSplitted[i].toUpperCase() !== messageSplitted[i].toUpperCase()) {
              return false;
            }
          }
        }
        return true;
      }).slice(0, CONFIG.suggestionLimit);

      // regex is literal aids
      const currentParamIndex = this.message.match(/(| )([^\s"]+|"([^"]*)"| $)/g).length - 2;

      currentSuggestions.forEach((s) => {
        s.disabled = !s.name.toUpperCase().startsWith(this.message.toUpperCase());
        s.params.forEach((p, index) => {
          if (currentParamIndex >= 0) {
            p.disabled = (index !== currentParamIndex);
          } else {
            p.disabled = true;
          }
        });
      });

      currentSuggestions.sort((a, b) => {
        var nameA = a.name.toUpperCase();
        var nameB = b.name.toUpperCase();
        if (nameA < nameB) {
          return -1;
        }
        if (nameA > nameB) {
          return 1;
        }
        return 0;
      });
      
      this.$emit('suggestionsChange', currentSuggestions);
      return currentSuggestions;
    },
  },
  methods: {},
});
