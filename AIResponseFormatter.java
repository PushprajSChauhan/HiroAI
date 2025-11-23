package hiroaiapp.utils;

public class AIResponseFormatter {
    public static String improveAIResponse(String text) {
        if (text == null || text.trim().isEmpty()) {
            return "";
        }

        String formatted = text;

        // 1. Remove citations [1], [2], etc.
        formatted = formatted.replaceAll("\\[\\d+\\]", "");

        // 2. Convert bold: **text** to <strong>text</strong>
        formatted = formatted.replaceAll("\\*\\*(.+?)\\*\\*", "<strong>$1</strong>");

        // 3. Convert italic: *text* to <em>text</em>
        formatted = formatted.replaceAll("\\*([^*\\n]+?)\\*", "<em>$1</em>");

        // 4. Handle Tables
        formatted = formatTables(formatted);

        // 5. Handle bullet points
        formatted = formatted.replaceAll("\\n- ", "<br/>• ");

        // 6. Convert double line breaks to paragraphs
        formatted = formatted.replaceAll("\\n\\n", "<br/><br/>");

        // 7. Convert single line breaks
        formatted = formatted.replaceAll("\\n", "<br/>");

        // 8. Clean up multiple spaces
        formatted = formatted.replaceAll(" +", " ").trim();

        return formatted;
    }

    private static String formatTables(String text) {
        // Check if text contains table (lines with |)
        if (!text.contains("|")) {
            return text;
        }

        StringBuilder result = new StringBuilder();
        String[] lines = text.split("\\n");
        boolean inTable = false;
        boolean isHeader = false;

        for (int i = 0; i < lines.length; i++) {
            String line = lines[i].trim();

            // Check if this line is a table row
            if (line.contains("|")) {
                // Start table if not already started
                if (!inTable) {
                    result.append("<div style='overflow-x: auto; margin: 1.5rem 0; box-shadow: 0 2px 8px rgba(0,0,0,0.1); border-radius: 8px;'>");
                    result.append("<table style='width: 100%; border-collapse: collapse; background: #ffffff; border-radius: 8px; overflow: hidden;'>");
                    inTable = true;
                    isHeader = true;
                }

                // Skip the separator line (contains only |, -, and spaces)
                if (line.matches("[|\\-\\s:]+")) {
                    continue;
                }

                // Split by | and clean
                String[] cells = line.split("\\|");

                if (isHeader) {
                    result.append("<thead><tr style='background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);'>");
                    for (String cell : cells) {
                        String cleanCell = cell.trim();
                        if (!cleanCell.isEmpty()) {
                            result.append("<th style='padding: 1rem 1.25rem; border: none; text-align: center; font-weight: 600; color: #ffffff; font-size: 0.95rem; letter-spacing: 0.5px;'>")
                                    .append(cleanCell)
                                    .append("</th>");
                        }
                    }
                    result.append("</tr></thead><tbody>");
                    isHeader = false;
                } else {
                    result.append("<tr style='border-bottom: 1px solid #e2e8f0; text-align: center; transition: background-color 0.2s ease;' onmouseover='this.style.backgroundColor=\"#f8fafc\"' onmouseout='this.style.backgroundColor=\"transparent\"'>");
                    for (String cell : cells) {
                        String cleanCell = cell.trim();
                        if (!cleanCell.isEmpty()) {
                            result.append("<td style='padding: 0.875rem 1.25rem; border: none; color: #334155; font-size: 0.9rem; line-height: 1.6;'>")
                                    .append(cleanCell)
                                    .append("</td>");
                        }
                    }
                    result.append("</tr>");
                }
            } else {
                // Close table if we were in one
                if (inTable) {
                    result.append("</tbody></table></div>\n");
                    inTable = false;
                }
                result.append(line).append("\n");
            }
        }

        // Close table if still open
        if (inTable) {
            result.append("</tbody></table></div>\n");
        }

        return result.toString();
    }
}
