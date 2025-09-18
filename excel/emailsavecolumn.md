### `Control Panel` Sheet
* **Cell C4:** Dropdown list for selecting template.
* **Cell C6:** Type the name for a new template here before importing.
* **Button 1:** Runs `GenerateEmailFromTemplate`.
* **Button 2:** Runs `ImportTemplateFromFile`.

### `Templates` Sheet
| A | B | C | D | E |
| :--- | :--- | :--- | :--- | :--- |
| **TemplateName** | **EmailSubject** | **RecipientGroupName**| **CC** | **HTMLBody** |
| (Filled by import) | (Filled by import) | (You type this in) | (You type this in) | (Filled by import) |

### `RecipientGroups` Sheet
| A | B |
| :--- | :--- |
| **GroupName** | **Recipients** |
| Group_SQs | email1; email2 |

### `Email Input` Sheet
| A | B | C |
| :--- | :--- | :--- |
| **TemplateName**| **Placeholder** | **Value** |
| S_Q_Comm | `[Date]` | Sept 18, 2025 |
