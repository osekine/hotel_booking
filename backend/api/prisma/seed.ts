import { PrismaClient, BookingStatus } from "@prisma/client";

const prisma = new PrismaClient();

function dt(iso: string) {
    return new Date(iso);
}

export async function seedIfNeeded() {
    const hotelsCount = await prisma.hotel.count();
    if (hotelsCount > 0) {
        console.log("[seed] skipped (data already exists)");
        return;
    }

    console.log("[seed] creating demo data...");

    const hotel1 = await prisma.hotel.create({
        data: { name: "Canal View Hotel", city: "Amsterdam" },
    });

    const hotel2 = await prisma.hotel.create({
        data: { name: "Old Town Inn", city: "Utrecht" },
    });

    const roomsH1 = await prisma.room.createManyAndReturn({
        data: [
            { hotelId: hotel1.id, number: "101", title: "Standard", capacity: 2, priceEur: 120 },
            { hotelId: hotel1.id, number: "102", title: "Deluxe", capacity: 3, priceEur: 160 },
            { hotelId: hotel1.id, number: "201", title: "Suite", capacity: 4, priceEur: 240 },
        ],
    });

    const roomsH2 = await prisma.room.createManyAndReturn({
        data: [
            { hotelId: hotel2.id, number: "1A", title: "Standard", capacity: 2, priceEur: 90 },
            { hotelId: hotel2.id, number: "2B", title: "Family", capacity: 4, priceEur: 150 },
        ],
    });

    // Брони для демонстрации:
    // room 101: занято [2026-03-10, 2026-03-15)
    // room 101: занято [2026-03-18, 2026-03-20)
    await prisma.booking.createMany({
        data: [
            {
                roomId: roomsH1.find(r => r.number === "101")!.id,
                guestName: "Alice",
                startDate: dt("2026-03-10T00:00:00.000Z"),
                endDate: dt("2026-03-15T00:00:00.000Z"),
                status: BookingStatus.ACTIVE,
            },
            {
                roomId: roomsH1.find(r => r.number === "101")!.id,
                guestName: "Bob",
                startDate: dt("2026-03-18T00:00:00.000Z"),
                endDate: dt("2026-03-20T00:00:00.000Z"),
                status: BookingStatus.ACTIVE,
            },
            // room 2B: бронь, которую отменили (не блокирует)
            {
                roomId: roomsH2.find(r => r.number === "2B")!.id,
                guestName: "Charlie",
                startDate: dt("2026-03-12T00:00:00.000Z"),
                endDate: dt("2026-03-14T00:00:00.000Z"),
                status: BookingStatus.CANCELED,
                canceledAt: dt("2026-03-01T00:00:00.000Z"),
            },
        ],
    });

    console.log("[seed] done ✅");
}

if (require.main === module) {
    seedIfNeeded()
        .catch((e) => {
            console.error("[seed] error", e);
            process.exit(1);
        })
        .finally(async () => {
            await prisma.$disconnect();
        });
}
