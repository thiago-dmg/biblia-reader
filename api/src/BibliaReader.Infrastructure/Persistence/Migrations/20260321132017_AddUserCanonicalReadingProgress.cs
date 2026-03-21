using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace BibliaReader.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddUserCanonicalReadingProgress : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "UserCanonicalReadingProgresses",
                columns: table => new
                {
                    UserId = table.Column<Guid>(type: "uuid", nullable: false),
                    SelectedPlanId = table.Column<string>(type: "character varying(32)", maxLength: 32, nullable: false),
                    PlanStartedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    CompletedChapterIdsJson = table.Column<string>(type: "jsonb", nullable: false),
                    UpdatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserCanonicalReadingProgresses", x => x.UserId);
                    table.ForeignKey(
                        name: "FK_UserCanonicalReadingProgresses_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "UserCanonicalReadingProgresses");
        }
    }
}
