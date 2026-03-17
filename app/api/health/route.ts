import { NextResponse } from "next/server";

export async function GET() {
  return NextResponse.json(
    { status: "Healthy", timestamp: new Date().toISOString() }, 
    { status: 200 }
  );
}