package com.ict4dg19.intergo.util;

import com.itextpdf.kernel.colors.DeviceRgb;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import com.itextpdf.layout.element.LineSeparator;
import com.itextpdf.kernel.pdf.canvas.draw.SolidLine;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class PdfExportUtil {

    public static void exportToPdf(HttpServletResponse response, String title, String[] headers, List<String[]> data, String filename) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

        PdfWriter writer = new PdfWriter(response.getOutputStream());
        PdfDocument pdf = new PdfDocument(writer);
        Document document = new Document(pdf);
        document.setMargins(36, 36, 36, 36); // Clean 0.5 inch margins

        // Colors
        DeviceRgb primaryColor = new DeviceRgb(99, 102, 241); // Indigo
        DeviceRgb darkSlate = new DeviceRgb(30, 41, 59);      // Slate-800
        DeviceRgb textMuted = new DeviceRgb(100, 116, 139);   // Slate-500
        DeviceRgb borderGray = new DeviceRgb(226, 232, 240);  // Slate-200
        DeviceRgb zebraColor = new DeviceRgb(248, 250, 252);  // Slate-50

        // 1. Header Metadata Table (2 columns: Company Title, Generation Date)
        Table headerMeta = new Table(UnitValue.createPercentArray(new float[]{50, 50})).useAllAvailableWidth();
        headerMeta.setBorder(com.itextpdf.layout.borders.Border.NO_BORDER);

        Cell logoCell = new Cell()
                .add(new Paragraph("INTERGO RH")
                        .setBold()
                        .setFontSize(14)
                        .setFontColor(primaryColor))
                .setTextAlignment(TextAlignment.LEFT)
                .setBorder(com.itextpdf.layout.borders.Border.NO_BORDER);

        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        String formattedDate = LocalDateTime.now().format(dtf);
        Cell dateCell = new Cell()
                .add(new Paragraph("Généré le : " + formattedDate)
                        .setFontSize(9)
                        .setFontColor(textMuted))
                .setTextAlignment(TextAlignment.RIGHT)
                .setBorder(com.itextpdf.layout.borders.Border.NO_BORDER);

        headerMeta.addCell(logoCell);
        headerMeta.addCell(dateCell);
        document.add(headerMeta);

        // Thin separator rule
        SolidLine lineDraw = new SolidLine(0.8f);
        lineDraw.setColor(primaryColor);
        LineSeparator separator = new LineSeparator(lineDraw);
        separator.setMarginBottom(20);
        document.add(separator);

        // 2. Document Title
        Paragraph titleParagraph = new Paragraph(title)
                .setFontColor(darkSlate)
                .setBold()
                .setFontSize(18)
                .setMarginBottom(15);
        document.add(titleParagraph);

        // 3. Data Table
        Table table = new Table(UnitValue.createPercentArray(headers.length)).useAllAvailableWidth();

        // Table Header Row
        for (String header : headers) {
            Cell cell = new Cell()
                    .add(new Paragraph(header)
                            .setBold()
                            .setFontSize(10)
                            .setFontColor(com.itextpdf.kernel.colors.ColorConstants.WHITE))
                    .setBackgroundColor(primaryColor)
                    .setTextAlignment(TextAlignment.LEFT)
                    .setPadding(8)
                    .setBorder(new com.itextpdf.layout.borders.SolidBorder(primaryColor, 1f));
            table.addHeaderCell(cell);
        }

        // Table Data Rows
        int rowIndex = 0;
        for (String[] row : data) {
            boolean isZebra = (rowIndex % 2 == 1);
            DeviceRgb bgColor = isZebra ? zebraColor : new DeviceRgb(255, 255, 255);

            for (String cellData : row) {
                Cell cell = new Cell()
                        .add(new Paragraph(cellData != null ? cellData : "")
                                .setFontSize(9)
                                .setFontColor(darkSlate))
                        .setBackgroundColor(bgColor)
                        .setPadding(6)
                        .setBorder(new com.itextpdf.layout.borders.SolidBorder(borderGray, 0.5f));
                table.addCell(cell);
            }
            rowIndex++;
        }

        document.add(table);
        document.close();
    }
}
