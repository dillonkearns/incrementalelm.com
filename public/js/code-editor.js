const formatter = new Intl.DateTimeFormat("en-US", {
  weekday: "long",
  month: "long",
  day: "numeric",
  timeZoneName: "short",
  hour: "numeric",
  minute: "numeric",
});

customElements.define(
  "intl-time",
  class extends HTMLElement {
    constructor() {
      super();
      this._editorValue = null;
    }

    get editorValue() {
      return this._editorValue;
    }

    set editorValue(value) {
      if (this._editorValue === value) return;
      this._editorValue = value;
      if (!this._editor) return;
      this._editor.setValue(value);
    }

    attributeChangedCallback(name, oldValue, newValue) {}

    connectedCallback() {
      this.innerHTML = formatter.format(new Date(this._editorValue));
    }
  }
);
