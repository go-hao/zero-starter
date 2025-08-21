package {{.pkg}}

import (
	"fmt"
	"strings"

	"github.com/zeromicro/go-zero/core/stores/sqlx"
)

var ErrNotFound = sqlx.ErrNotFound

const tableAlias = "mt"

type PaginationOrderBy struct {
	OrderBy  string
	IsDesc   bool
	Page     int64
	PageSize int64
}

const (
	defaultPage     = 1
	defaultPageSize = 10
	maxPageSize     = 100
)

var allowedOrderBy = map[string]bool{
	"id":         true,
	"name":       true,
	"created_at": true,
}

func buildRowsWithTableAlias(fieldNames []string) string {
	rows := ""
	for _, name := range fieldNames {
		rows += fmt.Sprintf("%s.%s,", tableAlias, name)
	}
    rows, _ = strings.CutSuffix(rows, ",")

	return rows
}

// getOrderBy returns order by string
//
// return empty string if orderBy is empty
func getOrderBy(orderBy string, isDesc bool) string {
	if len(orderBy) == 0 {
		return ""
	}

	if !allowedOrderBy[orderBy] {
		return ""
	}

	fieldName := orderBy
	order := "asc"

	if isDesc {
		order = "desc"
	}

	return fmt.Sprintf("order by %s.`%s` %s", tableAlias, fieldName, order)
}

// getPagination validates page and pageSize, calculates offset
//
// and returns pagination string: "limit %d offset %d"
//
// if page <= 0, page = defaultPage
//
// if pageSize <= 0, pageSize = defaultPageSize
//
// if pageSize > maxPageSize, pageSize = maxPageSize
func getPagination(page int64, pageSize int64) string {
	if page <= 0 {
		page = defaultPage
	}
	if pageSize <= 0 {
		pageSize = defaultPageSize
	}
	if pageSize > maxPageSize {
		pageSize = maxPageSize
	}

	offset := (page - 1) * pageSize

	return fmt.Sprintf("limit %d offset %d", pageSize, offset)
}

func getPaginationOrderBy(paginationOrderBy *PaginationOrderBy) string {
	if paginationOrderBy == nil {
		return getPagination(defaultPage, defaultPageSize)
	}

	o := getOrderBy(paginationOrderBy.OrderBy, paginationOrderBy.IsDesc)
	p := getPagination(paginationOrderBy.Page, paginationOrderBy.PageSize)

	if len(o) == 0 {
		return p
	}

	return fmt.Sprintf("%s %s", o, p)
}

// getArgsPlaceholders returns string like (?,?,?) the number of ? depends on the length of argsToAppend
// do NOT pass an empty slice
func getArgsPlaceholders[T any](argsToAppend []T) string {
	length := len(argsToAppend)
	placeholders := make([]string, length)
	for i := range length {
		placeholders[i] = "?"
	}

	return fmt.Sprintf("(%s)", strings.Join(placeholders, ","))
}

// appendArgs appends elements to the end of args
//
// do NOT pass an empty slice
func appendArgs[T any](args []any, argsToAppend []T) []any {
	length := len(argsToAppend)
	anyArgsToAppend := make([]any, length)
	for i := range length {
		anyArgsToAppend[i] = argsToAppend[i]
	}

	return append(args, anyArgsToAppend...)
}
