# Email Template Generator Setup

### How to Use

**One-Time Setup (for a new template)**
1.  Save the master email as a `.msg` file from Outlook.
2.  On the `Input` sheet, type a name for the new template in cell **B6**.
3.  Click the **Import Template** button and select the `.msg` file.
4.  A series of input boxes will ask for the placeholder names (e.g., `[Date]`). Enter each one and click OK. Click OK on a blank box to finish.
5.  The template is now ready for use.

**Daily Use**
1.  On the `Input` sheet, select a **Template** from the dropdown in cell **B3**. The required fields will automatically appear below row 8.
2.  Select a **To** group from the dropdown in cell **B4**.
3.  Type any **CC** addresses in cell **B5**.
4.  Fill in the values for the fields in the dynamic area (column B, starting at row 8).
5.  Click the **Generate Email** button.

---

### Sheet Layouts

#### `Input` Sheet
This is the main control panel. The area from row 8 downwards is dynamic and changes based on the template selected in B3.

| | A | B |
| :-- | :--- | :--- |
| **3** | Template: | (Dropdown for `TemplateName`) |
| **4** | To: | (Dropdown for `GroupName`) |
| **5** | CC: | (Type CC emails here) |
| **6** | New Template Name: | (Type name here before import) |
| **...** | | |
| **8** | **(Field Name)** | **(Your Value)** |
| **9** | (Auto-populates) | (You type here) |
| **...** | ... | ... |

#### `TemplateFields` Sheet (Hidden)
This is a hidden master list that controls the dynamic form on the `Input` sheet. The import process populates this sheet for you.

| TemplateName | FieldName |
| :--- | :--- |
| S_Q_Comm | `[Date]` |
| S_Q_Comm | `[XSOAR_Title]` |
| WeeklyUpdate | `[Greeting]` |

#### `Templates` Sheet
This sheet stores the template itself. It is populated automatically by the "Import" button.

| TemplateName | EmailSubject | HTMLBody |
| :--- | :--- | :--- |
| S_Q_Comm | Cyber Threat Fusion... | `<!DOCTYPE html>...` |
| WeeklyUpdate | Weekly Status Update | `<!DOCTYPE html>...` |

#### `RecipientGroups` Sheet
This sheet stores the predefined email distribution lists.

| GroupName | Recipients |
| :--- | :--- |
| Group_SQs | user1@email.com; user2@email.com |
| Leadership | manager1@email.com |
