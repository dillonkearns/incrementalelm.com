// import CodeMirror from "codemirror";
// import CodeMirror from "codemirror/lib/codemirror.js";
import CodeMirror from "codemirror";

import "codemirror/lib/codemirror.css";
import elm from "codemirror/mode/elm/elm.js";

// import * as style from "../../lib/codemirror.css";
// import * as CodeMirror from "../../lib/codemirror.js";
// import * as elmHighlight from "../../lib/elm-highlighting.js";
// <link rel="stylesheet" href="../lib/codemirror.css" />
// <script type="text/javascript" src="../lib/codemirror.js"></script>
// <script type="text/javascript" src="../lib/elm-highlighting.js"></script>
// import * as CodeMirror from "codemirror";

customElements.define(
  "code-editor",
  class extends HTMLElement {
    constructor() {
      super();
      this._editorValue =
        "-- If you see this, the Elm code didn't set the value.";
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

    connectedCallback() {
      this._editor = CodeMirror(this, {
        identUnit: 4,
        viewportMargin: Infinity,
        mode: "elm",
        lineNumbers: false,
        readOnly: "nocursor",
        value: this._editorValue
      });
    }
  }
);
