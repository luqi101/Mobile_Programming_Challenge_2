from pathlib import Path
import re
from xml.sax.saxutils import escape

from reportlab.lib import colors
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.platypus import (
    Image,
    KeepTogether,
    ListFlowable,
    ListItem,
    PageBreak,
    Paragraph,
    Preformatted,
    SimpleDocTemplate,
    Spacer,
    Table,
    TableStyle,
)


ROOT = Path(__file__).resolve().parents[1]
README = ROOT / "README.md"
OUTPUT = ROOT / "README.pdf"

SCREENSHOTS = [
    ("Home", "Firm hero, calls to action, and Cloud Firestore source indicator.", "docs/screenshots/01_home.png"),
    ("Practice Areas", "Firestore-backed service cards.", "docs/screenshots/02_practice_areas.png"),
    ("Services List", "Additional practice area cards.", "docs/screenshots/03_practice_areas_more.png"),
    ("Service Detail", "Practice area detail with educational disclaimer.", "docs/screenshots/04_practice_area_detail.png"),
    ("Team", "Fictional attorney portfolio cards.", "docs/screenshots/05_team.png"),
    ("Attorney Detail", "Attorney profile detail and contact action.", "docs/screenshots/06_attorney_detail.png"),
    ("Resources", "Original legal insight cards.", "docs/screenshots/07_resources.png"),
    ("Resource Detail", "Legal resource article view.", "docs/screenshots/08_resource_detail.png"),
    ("Contact Form", "Validated consultation request form.", "docs/screenshots/09_contact_form.png"),
    ("FAQ", "Firestore-backed FAQ list.", "docs/screenshots/10_faq_collapsed.png"),
    ("Expanded FAQ", "Expanded FAQ answers.", "docs/screenshots/11_faq_expanded.png"),
]


def footer(canvas, doc):
    canvas.saveState()
    canvas.setFont("Helvetica", 8)
    canvas.setFillColor(colors.HexColor("#64748B"))
    canvas.drawString(0.72 * inch, 0.45 * inch, "Aadil & Partners Legal - CS5450 Challenge 2")
    canvas.drawRightString(7.78 * inch, 0.45 * inch, f"Page {doc.page}")
    canvas.restoreState()


def clean_inline(text):
    text = re.sub(r"\[([^\]]+)\]\(([^)]+)\)", r"\1 (\2)", text)
    text = text.replace("**", "")
    pieces = re.split(r"(`[^`]+`)", text)
    cleaned = []
    for piece in pieces:
        if piece.startswith("`") and piece.endswith("`"):
            cleaned.append(f"<font name='Courier'>{escape(piece[1:-1])}</font>")
        else:
            cleaned.append(escape(piece))
    return "".join(cleaned)


def flush_paragraph(buffer, story, styles):
    if not buffer:
        return
    text = " ".join(buffer).strip()
    if text:
        story.append(Paragraph(clean_inline(text), styles["Body"]))
        story.append(Spacer(1, 6))
    buffer.clear()


def parse_markdown_table(lines):
    rows = []
    for line in lines:
        cells = [cell.strip() for cell in line.strip().strip("|").split("|")]
        if not cells or all(re.fullmatch(r":?-{3,}:?", cell or "") for cell in cells):
            continue
        rows.append(cells)
    return rows


def table_widths(rows):
    if not rows:
        return []
    columns = max(len(row) for row in rows)
    if columns == 2:
        first_header = rows[0][0].lower()
        if "student" in first_header:
            return [1.25 * inch, 5.35 * inch]
        if "collection" in first_header:
            return [2.15 * inch, 4.45 * inch]
        if "file" in first_header:
            return [2.65 * inch, 3.95 * inch]
        return [1.85 * inch, 4.75 * inch]
    return [6.6 * inch / columns for _ in range(columns)]


def build_table(rows, styles):
    normalized = []
    columns = max(len(row) for row in rows)
    for row in rows:
        padded = row + [""] * (columns - len(row))
        normalized.append([Paragraph(clean_inline(cell), styles["TableCell"]) for cell in padded])
    return Table(
        normalized,
        colWidths=table_widths(rows),
        repeatRows=1,
        style=TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#0B1F3A")),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
                ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                ("BACKGROUND", (0, 1), (-1, -1), colors.white),
                ("GRID", (0, 0), (-1, -1), 0.25, colors.HexColor("#E7E0D4")),
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
                ("PADDING", (0, 0), (-1, -1), 6),
                ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.white, colors.HexColor("#F8F5EF")]),
            ]
        ),
    )


def screenshot_cell(title, description, relative_path, styles):
    path = ROOT / relative_path
    if not path.exists():
        return [
            Paragraph(title, styles["ScreenshotTitle"]),
            Paragraph(f"Missing screenshot: {relative_path}", styles["Body"]),
        ]
    image = Image(str(path))
    image.drawWidth = 2.15 * inch
    image.drawHeight = 4.78 * inch
    return [
        Paragraph(title, styles["ScreenshotTitle"]),
        Spacer(1, 4),
        image,
        Spacer(1, 5),
        Paragraph(description, styles["Caption"]),
    ]


def add_screenshot_appendix(story, styles):
    story.append(PageBreak())
    story.append(Paragraph("Screenshot Appendix", styles["Heading"]))
    story.append(
        Paragraph(
            "The following Android screenshots are bundled with the project and referenced by the README.",
            styles["Body"],
        )
    )
    story.append(Spacer(1, 8))

    for index in range(0, len(SCREENSHOTS), 2):
        pair = SCREENSHOTS[index : index + 2]
        row = [screenshot_cell(*item, styles) for item in pair]
        if len(row) == 1:
            row.append("")
        story.append(
            KeepTogether(
                Table(
                    [row],
                    colWidths=[3.25 * inch, 3.25 * inch],
                    style=TableStyle(
                        [
                            ("VALIGN", (0, 0), (-1, -1), "TOP"),
                            ("BOX", (0, 0), (-1, -1), 0.25, colors.HexColor("#E7E0D4")),
                            ("INNERGRID", (0, 0), (-1, -1), 0.25, colors.HexColor("#E7E0D4")),
                            ("BACKGROUND", (0, 0), (-1, -1), colors.HexColor("#FBFAF7")),
                            ("PADDING", (0, 0), (-1, -1), 8),
                        ]
                    ),
                )
            )
        )
        if index + 2 < len(SCREENSHOTS):
            story.append(PageBreak())


def build_pdf():
    styles = getSampleStyleSheet()
    styles.add(
        ParagraphStyle(
            name="TitleCustom",
            parent=styles["Title"],
            textColor=colors.HexColor("#0B1F3A"),
            fontName="Helvetica-Bold",
            fontSize=24,
            leading=30,
            spaceAfter=12,
        )
    )
    styles.add(
        ParagraphStyle(
            name="Heading",
            parent=styles["Heading2"],
            textColor=colors.HexColor("#0B1F3A"),
            fontName="Helvetica-Bold",
            fontSize=15,
            leading=19,
            spaceBefore=12,
            spaceAfter=8,
        )
    )
    styles.add(
        ParagraphStyle(
            name="Subheading",
            parent=styles["Heading3"],
            textColor=colors.HexColor("#1F2933"),
            fontName="Helvetica-Bold",
            fontSize=11,
            leading=14,
            spaceBefore=8,
            spaceAfter=5,
        )
    )
    styles.add(
        ParagraphStyle(
            name="Body",
            parent=styles["BodyText"],
            fontName="Helvetica",
            fontSize=9.4,
            leading=13.2,
            textColor=colors.HexColor("#1F2933"),
        )
    )
    styles.add(
        ParagraphStyle(
            name="TableCell",
            parent=styles["Body"],
            fontSize=8.7,
            leading=11.2,
        )
    )
    styles.add(
        ParagraphStyle(
            name="Meta",
            parent=styles["Body"],
            textColor=colors.HexColor("#64748B"),
            fontSize=9,
            leading=12,
        )
    )
    styles.add(
        ParagraphStyle(
            name="Caption",
            parent=styles["Body"],
            textColor=colors.HexColor("#475569"),
            fontSize=8.3,
            leading=10.5,
        )
    )
    styles.add(
        ParagraphStyle(
            name="ScreenshotTitle",
            parent=styles["Body"],
            textColor=colors.HexColor("#0B1F3A"),
            fontName="Helvetica-Bold",
            fontSize=10,
            leading=12,
        )
    )

    doc = SimpleDocTemplate(
        str(OUTPUT),
        pagesize=letter,
        leftMargin=0.72 * inch,
        rightMargin=0.72 * inch,
        topMargin=0.72 * inch,
        bottomMargin=0.72 * inch,
        title="Aadil & Partners Legal README",
    )

    story = [
        Paragraph("Aadil & Partners Legal", styles["TitleCustom"]),
        Paragraph("CS5450 Mobile Programming - Challenge 2: Flutter Mobile Portfolio", styles["Meta"]),
        Paragraph("Group #1: Law Firm Portfolio", styles["Meta"]),
        Spacer(1, 10),
        Table(
            [
                ["App", "Aadil & Partners Legal"],
                ["Tagline", "Strategic Legal Counsel. Built on Trust."],
                ["GitHub", "https://github.com/luqi101/Mobile_Programming_Challenge_2.git"],
                ["Firebase project", "aadil-legal-g1-68e92"],
                ["Android package", "com.aadilpartners.legalportfolio"],
            ],
            colWidths=[1.45 * inch, 5.15 * inch],
            style=TableStyle(
                [
                    ("BACKGROUND", (0, 0), (0, -1), colors.HexColor("#F8F5EF")),
                    ("TEXTCOLOR", (0, 0), (-1, -1), colors.HexColor("#1F2933")),
                    ("FONTNAME", (0, 0), (0, -1), "Helvetica-Bold"),
                    ("GRID", (0, 0), (-1, -1), 0.25, colors.HexColor("#E7E0D4")),
                    ("VALIGN", (0, 0), (-1, -1), "TOP"),
                    ("PADDING", (0, 0), (-1, -1), 7),
                ]
            ),
        ),
        Spacer(1, 12),
    ]

    lines = README.read_text(encoding="utf-8").splitlines()
    paragraph_buffer = []
    bullet_buffer = []
    code_buffer = []
    table_buffer = []
    in_code = False

    def flush_bullets():
        nonlocal bullet_buffer
        if bullet_buffer:
            story.append(
                ListFlowable(
                    [ListItem(Paragraph(clean_inline(item), styles["Body"])) for item in bullet_buffer],
                    bulletType="bullet",
                    leftIndent=16,
                )
            )
            story.append(Spacer(1, 6))
            bullet_buffer = []

    def flush_code():
        nonlocal code_buffer
        if code_buffer:
            story.append(
                Preformatted(
                    "\n".join(code_buffer),
                    ParagraphStyle(
                        name="CodeBlock",
                        fontName="Courier",
                        fontSize=7.2,
                        leading=9.0,
                        backColor=colors.HexColor("#F8F5EF"),
                        borderColor=colors.HexColor("#E7E0D4"),
                        borderWidth=0.25,
                        borderPadding=6,
                    ),
                )
            )
            story.append(Spacer(1, 8))
            code_buffer = []

    def flush_table():
        nonlocal table_buffer
        if table_buffer:
            rows = parse_markdown_table(table_buffer)
            if rows:
                story.append(build_table(rows, styles))
                story.append(Spacer(1, 8))
            table_buffer = []

    for raw_line in lines[1:]:
        line = raw_line.rstrip()
        stripped = line.strip()

        if stripped.startswith("```"):
            flush_table()
            if in_code:
                flush_code()
                in_code = False
            else:
                flush_paragraph(paragraph_buffer, story, styles)
                flush_bullets()
                in_code = True
            continue

        if in_code:
            code_buffer.append(line)
            continue

        if stripped.startswith("<"):
            flush_paragraph(paragraph_buffer, story, styles)
            flush_bullets()
            flush_table()
            continue

        if not stripped:
            flush_paragraph(paragraph_buffer, story, styles)
            flush_bullets()
            flush_table()
            continue

        if stripped.startswith("|"):
            flush_paragraph(paragraph_buffer, story, styles)
            flush_bullets()
            table_buffer.append(stripped)
            continue

        flush_table()

        if stripped.startswith("## "):
            flush_paragraph(paragraph_buffer, story, styles)
            flush_bullets()
            heading = stripped[3:].strip()
            if heading in {"Project Structure", "Screenshots"}:
                story.append(PageBreak())
            story.append(Paragraph(clean_inline(heading), styles["Heading"]))
            continue

        if stripped.startswith("### "):
            flush_paragraph(paragraph_buffer, story, styles)
            flush_bullets()
            story.append(Paragraph(clean_inline(stripped[4:].strip()), styles["Subheading"]))
            continue

        if stripped.startswith("- "):
            flush_paragraph(paragraph_buffer, story, styles)
            bullet_buffer.append(stripped[2:].strip())
            continue

        if re.match(r"^\d+\. ", stripped):
            flush_paragraph(paragraph_buffer, story, styles)
            bullet_buffer.append(re.sub(r"^\d+\. ", "", stripped).strip())
            continue

        paragraph_buffer.append(stripped)

    flush_paragraph(paragraph_buffer, story, styles)
    flush_bullets()
    flush_table()
    flush_code()
    add_screenshot_appendix(story, styles)

    doc.build(story, onFirstPage=footer, onLaterPages=footer)
    print(f"Wrote {OUTPUT}")


if __name__ == "__main__":
    build_pdf()
